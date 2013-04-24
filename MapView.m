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
@synthesize moonSunCalc,annotationView,SunRiseSelect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SunRiseSelect = YES;
        userLocation = [[CLLocation alloc]init];
        userLocation = [[ShareLocation shareMyInstance] getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];

        
        mapViewController = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [mapViewController setMapType:MKMapTypeStandard];
        mapViewController.delegate = self;
        [mapViewController setShowsUserLocation:YES];
        [self addSubview:mapViewController];

        [self addPointAnnotation:18.39623 withLongitude:54.125975];
        
        UIButton *buttonHidenSunRise = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonHidenSunRise.frame = CGRectMake(240, 400, 70, 50);
        [buttonHidenSunRise setTitle:@"Rise Sun" forState:UIControlStateNormal];
        [buttonHidenSunRise addTarget:self action:@selector(didClickToButtonHiddenRise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonHidenSunRise];
    }
    return self;
}

-(void)didUpdatePoint:(NSNotification *)notifi{
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    CLLocationCoordinate2D coord2 = [self.mapViewController convertPoint:point toCoordinateFromView:self.mapViewController];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateCoordinate" object:newLocation];
}

- (void)addPointAnnotation :(float)latitute withLongitude:(float)longitude
{
    CLLocationCoordinate2D coord;
    coord.latitude = latitute;
    coord.longitude = longitude;
    
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
            annotationView = [[AnnotationPointView alloc]initWithAnnotation:annotation reuseIdentifier:identifier withDate:[NSDate date] withLatitude:18.39623 withLongitude:54.125975];
        }
    }
    return annotationView;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch *touch = [[event allTouches] anyObject];
//    location = [touch locationInView:self.mapViewController];
//    UIImage *sunSetImage = [UIImage imageNamed:@"icon_you@2x.png"];
//    youPointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100 ,100, 25, 31)];
//    youPointImageView.image = sunSetImage;
//    youPointImageView.center = location;
//    [self addSubview:youPointImageView];
//    [self setNeedsDisplay];
//}

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

- (IBAction)didClickToButtonHiddenRise:(id)sender
{
    if (SunRiseSelect == NO) {
        SunRiseSelect = YES;
    }
    else{
        SunRiseSelect = NO;
    }

    NSLog(@"select : %d",SunRiseSelect);
}

@end
