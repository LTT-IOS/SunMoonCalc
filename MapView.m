//
//  MapView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MapView.h"
#import "AnnotationPointView.h"
#import "ShareLocation.h"
#import "CenterAnnotationView.h"
#import "BackgroudMapView.h"

@implementation MapView
@synthesize annotationPoint,userLocation;
@synthesize positionEntity,mapViewController;
@synthesize annotationView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        userLocation = [[CLLocation alloc]init];
        userLocation = [[ShareLocation shareMyInstance] getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];
        
        locationPointCenter.x = 160;
        locationPointCenter.y = 230;

        mapViewController = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        [mapViewController setMapType:MKMapTypeStandard];
        mapViewController.delegate = self;
        [mapViewController setShowsUserLocation:YES];
        [self addSubview:self.mapViewController];
        
        
//        BackgroudMapView *backgroundView = [[BackgroudMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
//        backgroundView.opaque = NO;
//        [self addSubview:backgroundView];

        [self addPointAnnotation:userLocation.coordinate.latitude withLongitude:userLocation.coordinate.longitude];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef contextCamera = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextCamera, [UIColor redColor].CGColor);
    CGContextSetLineWidth(contextCamera, 2.0);
    CGContextMoveToPoint(contextCamera, 0, 0);
    CGContextAddLineToPoint(contextCamera, 200, 200);
    CGContextStrokePath(contextCamera);
    
}

-(void)didUpdatePoint:(NSNotification *)notifi{
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
    annotationPoint.coordinate = coord2;
    centerAnnotation.coordinate = coord2;
    coordinate2D = coord2;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateCoordinate" object:newLocation];
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
    [self.mapViewController addAnnotation:centerAnnotation];
    [self.mapViewController addAnnotation:annotationPoint];
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
            [self bringSubviewToFront:centerAnnotationView];
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
    return nil;
}


#pragma mark - update Location

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = nil;
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}


#pragma mark - button Hidden.

- (void)setupButton
{
    UIButton *buttonHidenSunRise = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonHidenSunRise.frame = CGRectMake(250, 400, 60, 50);
    [buttonHidenSunRise setTitle:@"Rise" forState:UIControlStateNormal];
    [buttonHidenSunRise addTarget:self action:@selector(didClickToButtonHiddenSunRise:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonHidenSunRise];
    
    UIButton *buttonHidenSunSet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonHidenSunSet.frame = CGRectMake(180, 400, 60, 50);
    [buttonHidenSunSet setTitle:@"Set" forState:UIControlStateNormal];
    [buttonHidenSunSet addTarget:self action:@selector(didClickToButtonHiddenSunSet:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonHidenSunSet];
    
    UIButton *buttonHidenSunPoint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonHidenSunPoint.frame = CGRectMake(110, 400, 60, 50);
    [buttonHidenSunPoint setTitle:@"Point" forState:UIControlStateNormal];
    [buttonHidenSunPoint addTarget:self action:@selector(didClickToButtonHiddenSunPoint:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonHidenSunPoint];
    
    UIButton *buttonHidenAnnotation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonHidenAnnotation.frame = CGRectMake(40, 400, 60, 50);
    [buttonHidenAnnotation setTitle:@"hidden" forState:UIControlStateNormal];
    [buttonHidenAnnotation addTarget:self action:@selector(didClickToButtonHiddenPoint:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonHidenAnnotation];
}
- (IBAction)didClickToButtonHiddenPoint:(id)sender
{
    if (hiddenAnnotation == NO) {
        [[self.mapViewController viewForAnnotation:centerAnnotation] setHidden:YES];
        [[self.mapViewController viewForAnnotation:annotationPoint] setHidden:YES];
        hiddenAnnotation = YES;
    }
    else{
        [[self.mapViewController viewForAnnotation:centerAnnotation] setHidden:NO];
        [[self.mapViewController viewForAnnotation:annotationPoint] setHidden:NO];
        
        hiddenAnnotation = NO;
    }
}

- (IBAction)didClickToButtonHiddenSunRise:(id)sender
{

    if (annotationPoint.HiddenSunRise == NO) {
        annotationPoint.HiddenSunRise = YES;
        [self.mapViewController setCenterCoordinate:self.mapViewController.region.center animated:NO];

    }
    else{

        annotationPoint.HiddenSunRise = NO;
    }
    [self.mapViewController removeAnnotation:annotationPoint];
    [self.mapViewController addAnnotation:annotationPoint];
}

- (IBAction)didClickToButtonHiddenSunSet:(id)sender
{
    
    if (annotationPoint.HiddenSunSet == NO) {
        annotationPoint.HiddenSunSet = YES;
    }
    else{
        
        annotationPoint.HiddenSunSet = NO;
    }
    [self.mapViewController removeAnnotation:annotationPoint];
    [self.mapViewController addAnnotation:annotationPoint];
}
- (IBAction)didClickToButtonHiddenSunPoint:(id)sender
{
    
    if (annotationPoint.HiddenSunPoint == NO) {
        annotationPoint.HiddenSunPoint = YES;
    }
    else{
        
        annotationPoint.HiddenSunPoint = NO;
    }
    [self.mapViewController removeAnnotation:annotationPoint];
    [self.mapViewController addAnnotation:annotationPoint];
}
@end
