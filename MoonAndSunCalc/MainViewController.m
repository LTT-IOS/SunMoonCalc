//
//  MainViewController.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/7/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MainViewController.h"
//#import "MapView.h"
#import "JSON.h"
#import "Utility.h"
#import "PlaceEntity.h"
#import "ShareLocation.h"
#import "CenterAnnotationView.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dateSlider,timeSlider,timeString,dateString,annotationPoint,annotationView,mapViewController,userLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpMapView];
        [self setUpSlider];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

# pragma mark - SearchBar
- (void)setUpSearchBar
{
    dataPlace = [[NSMutableData alloc]init];
    arrayPlaceEntity = [[NSMutableArray alloc]init];
    UIBarButtonItem * buttonDone = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(didchangeTextSearchBar:)];
    self.navigationItem.rightBarButtonItem = buttonDone;
    self.navigationController.navigationBarHidden = YES;
    
    searchBarPlace =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [searchBarPlace setDelegate:self];
    //    [self.view addSubview:searchBarPlace];
}


-(void)getPlaceDateWithText:(NSString*)textSearch{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=true&key=AIzaSyDjQt2mhVtMaLcjqtoC6ttU_y9e9K1iHb4",textSearch];
    NSLog(@"url : %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (urlConnection) {
        NSLog(@"connect");
    } else {
        NSLog(@"no connect");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSLog(@"respon : %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataPlace appendData:data];
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error is : %@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:dataPlace encoding:NSUTF8StringEncoding];
    NSDictionary *results = [responseString JSONValue];
    NSArray *arrayResults = [results objectForKey:@"results"];
    for (NSDictionary *dictPlace in arrayResults) {
        NSDictionary *dictGeometry = [dictPlace objectForKey:PlaceProperiesPlaceGeometry];
        
        NSDictionary *dictLocation = [dictGeometry objectForKey:PlaceProperiesPlaceLocation];
        NSString *latitude = [dictLocation objectForKey:PlaceProperiesPlaceLatitude];
        NSString *longitude = [dictLocation objectForKey:PlaceProperiesPlaceLongitude];
        NSString *placeAddress = [dictPlace objectForKey:PlaceProperiesPlaceAddress];
        
        NSMutableDictionary *place = [[NSMutableDictionary alloc]init];
        [place setObject:latitude forKey:PlaceProperiesPlaceLatitude];
        [place setObject:longitude forKey:PlaceProperiesPlaceLongitude];
        [place setObject:placeAddress forKey:PlaceProperiesPlaceAddress];
        PlaceEntity *placeEntity = [[PlaceEntity alloc]initWithDictionary:place];
        [arrayPlaceEntity addObject:placeEntity];
    }
    NSLog(@"results :%@",arrayResults);
}

- (void)didchangeTextSearchBar:(UISearchBar *)searchBar
{
    NSLog(@"text :%@",searchBarPlace.text);
    [self getPlaceDateWithText:searchBarPlace.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"hello");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
#pragma mark - Slider
- (void)setUpSlider
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    dateSlider = [[CustomSlider alloc]initWithFrame:CGRectMake(62, 400, 249, 23)];
    dateSlider.tag = 0;
    dateSlider.delegate = self;
    [dateSlider initSliderWith:UNIT_DAYS_IN_YEAR withFactor:1 withDateStyle:@"yyyy/MM/dd"];
    dateString = dateSlider.label.text;
    [self.view addSubview:dateSlider];
    [self.view addSubview:dateSlider.label];
    
    timeSlider = [[CustomSlider alloc]initWithFrame:CGRectMake(62, 430, 249, 23)];
    timeSlider.delegate = self;
    timeSlider.tag = 1;
    [timeSlider initSliderWith:UNIT_MINUTES_IN_DAY withFactor:30 withDateStyle:@"HH:mm"];
    timeString = timeSlider.label.text;
    [self.view addSubview:timeSlider];
    [self.view addSubview:timeSlider.label];
}

- (void)didChangeValue:(CustomSlider *)customSlider withValueString:(NSString *)valueString
{
    if (customSlider.tag == 0) {
        dateString = valueString;
    }
    if (customSlider.tag == 1) {
        timeString = valueString;
    }
    NSString *currentDateString = [NSString stringWithFormat:@"%@ %@:00",dateString,timeString];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateDate" object:currentDate];
}

#pragma mark - Mapview
- (void)setUpMapView
{

    userLocation = [[CLLocation alloc]init];
    userLocation = [[ShareLocation shareMyInstance] getOldLocation];
    coorCenter = userLocation.coordinate;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePointYou:) name:@"UpdatePointYou" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePointCamera:) name:@"UpdatePointCamera" object:nil];

    
    locationPointCenter.x = 160;
    locationPointCenter.y = 230;
    
    mapViewController = [[MoonSunCalcMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [mapViewController setMapType:MKMapTypeStandard];
    mapViewController.delegate = self;
    [mapViewController setShowsUserLocation:YES];
    [self.view addSubview:self.mapViewController];
    
    imageViewYou = [[CameraView alloc]initWithFrame:CGRectMake(0 , 0, 25, 32)];
    [self.view addSubview:imageViewYou];
    imageViewYou.hidden = YES;
    
    [self addPointAnnotation:userLocation.coordinate.latitude withLongitude:userLocation.coordinate.longitude];
    plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
    plotLocation[0] = coorYou;
    plotLocation[1] = coorCenter;
    line = [[MKPolyline alloc]init];
    line = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, 37, 48)];
//    [self.view addSubview:cameraView];
    cameraView.hidden = YES;
    isMoveCenter = NO;
    isFistTouches = NO;

}


- (void)addPointAnnotation :(float)latitute withLongitude:(float)longitude
{
    CLLocationCoordinate2D coord;
    coord.latitude = latitute;
    coord.longitude = longitude;
    coordinate2D = coord;
    
    MKCoordinateSpan span ;
    span.latitudeDelta = 50;
    span.longitudeDelta = 50;
	
    MKCoordinateRegion region;
    region.span = span;
    region.center = coord;
    [self.mapViewController setRegion:region animated:YES];
    centerAnnotation = [[CenterAnnotation alloc]initWithName:@"center" coordinate:coord];
    annotationPoint = [[AnnotationPoint alloc]initWithName:@"i'm here" coordinate:coord];
    youAnnotation = [[YouAnnotation alloc]initWithName:@"you" coordinate:coord];
    [self.mapViewController addAnnotation:centerAnnotation];
    [self.mapViewController addAnnotation:youAnnotation];

    [self.mapViewController addAnnotation:annotationPoint];
    [[self.mapViewController viewForAnnotation:youAnnotation] setHidden:YES];
}

- (void)plotRouteOnMap: (CLLocationCoordinate2D )lastLocation atCurrent2DLocation: (CLLocationCoordinate2D )currentLocation {
    
    plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
    plotLocation[0] = lastLocation;
    plotLocation[1] = currentLocation;
    line = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    [self.mapViewController addOverlay:line];
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        lineView.lineWidth = 2;
        lineView.strokeColor = [UIColor redColor];
        lineView.fillColor = [UIColor clearColor];
        return lineView;
    }
    return nil;
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSDate *date = [NSDate date];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:date] / 3600;
    NSDate *dateInput = [NSDate dateWithTimeIntervalSinceNow:timeZoneOffset*60*60];
    
    CenterAnnotationView * centerAnnotationView = nil;
    if ([annotation isKindOfClass:[CenterAnnotation class]]) {
        static NSString *idfr = @"center";
        centerAnnotationView = (CenterAnnotationView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:idfr];
        if (centerAnnotationView == nil) {
            centerAnnotationView = [[CenterAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:idfr withDate:dateInput withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
            [self.view bringSubviewToFront:centerAnnotationView];
        }
        return centerAnnotationView;
    }
    annotationView = nil;
    if ([annotation isKindOfClass:[AnnotationPoint class]]) {
        static NSString *identifier = @"AnnotationView";
        annotationView = (AnnotationPointView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            
            annotationView = [[AnnotationPointView alloc]initWithAnnotation:annotation reuseIdentifier:identifier withDate:dateInput withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        }
        return annotationView;
    }
    
    youAnnotationView = nil;
    if ([annotation isKindOfClass:[YouAnnotation class]]) {
        static NSString *identifier = @"YouAnnotationView";
        youAnnotationView = (YouAnnotationView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (youAnnotationView == nil) {
            
            youAnnotationView = [[YouAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        }
        return youAnnotationView;
    }
    return nil;
}


-(void)didUpdatePoint:(NSNotification *)notifi{
    isMoveCenter = YES;
    
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
    annotationPoint.coordinate = coord2;
    centerAnnotation.coordinate = coord2;
    coordinate2D = coord2;
    coorCenter = coord2;
    plotLocation[0] = coorYou;
    plotLocation[1] = coorCenter;
    line = [MKPolyline polylineWithCoordinates:plotLocation count:2];

    if (isFistTouches ==  YES) {
        [self.mapViewController removeOverlays:self.mapViewController.overlays];
        [self plotRouteOnMap:coorYou atCurrent2DLocation:coorCenter];
    }

    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateCoordinate" object:newLocation];
}

-(void)didUpdatePointYou:(NSNotification *)notifi{
    if (isMoveCenter == NO) {
        [self.mapViewController removeOverlays:self.mapViewController.overlays];
        NSValue *value = (NSValue *)[notifi object];
        CGPoint point = [value CGPointValue];
        CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
        cameraView.center = point;
        cameraView.hidden = NO;
        coorYou = coord2;
        youAnnotation.coordinate = coord2;
        [[self.mapViewController viewForAnnotation:youAnnotation] setHidden:NO];
        plotLocation[0] = coorYou;
        plotLocation[1] = coorCenter;
        
        line = [MKPolyline polylineWithCoordinates:plotLocation count:2];
        
        [self plotRouteOnMap:coorYou atCurrent2DLocation:coorCenter];
        isFistTouches = YES;

    }
    else{
        isMoveCenter = NO;
    }
}

-(void)didUpdatePointCamera:(NSNotification *)notifi{
    [self.mapViewController removeOverlays:self.mapViewController.overlays];
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
    coorYou = coord2;
    plotLocation[0] = coorYou;
    plotLocation[1] = coorCenter;
    line = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    [self.mapViewController removeOverlay:line];

    [self plotRouteOnMap:coorYou atCurrent2DLocation:coorCenter];
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = nil;
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}


@end
