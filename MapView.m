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

@implementation MapView
@synthesize annotationPoint,userLocation;
@synthesize positionEntity,mapViewController;
@synthesize moonSunCalc,annotationView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        userLocation = [[CLLocation alloc]init];
        userLocation = [[ShareLocation shareMyInstance] getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];

        
        mapViewController = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [mapViewController setMapType:MKMapTypeStandard];
        mapViewController.delegate = self;
        [mapViewController setShowsUserLocation:YES];
        [self addSubview:mapViewController];

        [self addPointAnnotation:37.030102 withLongitude:-115.780453];
        
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
    return self;
}

-(void)didUpdatePoint:(NSNotification *)notifi{
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
    annotationPoint.coordinate = coord2;
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
    annotationPoint = [[AnnotationPoint alloc]initWithName:@"i'm here" coordinate:coord];
    [self.mapViewController addAnnotation:annotationPoint];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
     annotationView = nil;
    static NSString *identifier = @"moonAnnotation";
    if ([annotation isKindOfClass:[AnnotationPoint class]]) {
        annotationView = (AnnotationPointView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[AnnotationPointView alloc]initWithAnnotation:annotation reuseIdentifier:identifier withDate:[NSDate date] withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        }
    }
    return annotationView;
}


- (void)drawRect:(CGRect)rect
{

    CGContextRef contextSunPoint = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunPoint, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(contextSunPoint, 2.0);
    CGContextMoveToPoint(contextSunPoint, locationPoint.x, locationPoint.y);
    CGContextAddLineToPoint(contextSunPoint,location.x,location.y );
    CGContextStrokePath(contextSunPoint);
}


#pragma mark - update Location

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = nil;
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}

- (IBAction)didClickToButtonHiddenPoint:(id)sender
{
    if (hiddenAnnotation == NO) {
        [[self.mapViewController viewForAnnotation:annotationPoint] setHidden:YES];
        hiddenAnnotation = YES;
    }
    else{
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
