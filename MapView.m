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

@implementation MapView
@synthesize annotationPoint,userLocation;
@synthesize positionEntity,mapViewController;
@synthesize moonSunCalc,annotationView;
@synthesize dateSlider;
@synthesize timeSlider;
@synthesize dateLabel;
@synthesize timeLabel;

NSDate *currentDate;
NSDate *currentTime;
NSDate *startDate;
NSDate *endDate;
NSDate *startTime;
NSCalendar *calendar;
NSDateComponents *component;
NSDateFormatter *dateFormatter;
NSDateFormatter *timeFormatter;

CGRect dateFrame;
CGRect timeFrame;
CGRect dateOriginFrame;
CGRect timeOriginFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        moonSunCalc = [[MoonSunCalcGobal alloc]init];
        self.backgroundColor = [UIColor clearColor];
        userLocation = [[CLLocation alloc]init];
        userLocation = [[ShareLocation shareMyInstance] getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];
        locationPointCenter.x = 160;
        locationPointCenter.y = 230;

        mapViewController = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [mapViewController setMapType:MKMapTypeStandard];
        mapViewController.delegate = self;
        [mapViewController setShowsUserLocation:YES];
        [self addSubview:mapViewController];
        
        
        imageViewYou = [[YouImageView alloc]initWithFrame:CGRectMake(0 , 0, 25, 32)];
        [self addSubview:imageViewYou];
        imageViewYou.hidden = YES;
        
        [self addPointAnnotation:47.989922 withLongitude:-46.406250];
        
//        UIButton *buttonHidenSunRise = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        buttonHidenSunRise.frame = CGRectMake(250, 400, 60, 50);
//        [buttonHidenSunRise setTitle:@"Rise" forState:UIControlStateNormal];
//        [buttonHidenSunRise addTarget:self action:@selector(didClickToButtonHiddenSunRise:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buttonHidenSunRise];
//        
//        UIButton *buttonHidenSunSet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        buttonHidenSunSet.frame = CGRectMake(180, 400, 60, 50);
//        [buttonHidenSunSet setTitle:@"Set" forState:UIControlStateNormal];
//        [buttonHidenSunSet addTarget:self action:@selector(didClickToButtonHiddenSunSet:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buttonHidenSunSet];
//        
//        UIButton *buttonHidenSunPoint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        buttonHidenSunPoint.frame = CGRectMake(110, 400, 60, 50);
//        [buttonHidenSunPoint setTitle:@"Point" forState:UIControlStateNormal];
//        [buttonHidenSunPoint addTarget:self action:@selector(didClickToButtonHiddenSunPoint:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buttonHidenSunPoint];
//        
//        UIButton *buttonHidenAnnotation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        buttonHidenAnnotation.frame = CGRectMake(40, 400, 60, 50);
//        [buttonHidenAnnotation setTitle:@"hidden" forState:UIControlStateNormal];
//        [buttonHidenAnnotation addTarget:self action:@selector(didClickToButtonHiddenPoint:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buttonHidenAnnotation];
//        [self setupSlider];
    }
    return self;
}
- (void)setupSlider
{
    dateSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 340, 300, 20)];
    timeSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 380, 300, 20)];

    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, 90, 20)];
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 340, 60, 20)];
    currentDate = [NSDate date];
    currentTime = [NSDate date];
    startDate = [NSDate date];
    endDate = [NSDate date];
    startTime = [NSDate date];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setDateFormat:@"HH:mm"];
    calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    component = [[NSDateComponents alloc]init];
    
    // Set the start time of a day.
    component = [calendar components:NSIntegerMax fromDate:currentTime];
    [component setHour:0];
    [component setMinute:0];
    startTime = [calendar dateFromComponents:component];
    
    // Set start date of a year
    component = [calendar components:NSYearCalendarUnit fromDate:startDate];
    [component setDay:1];
    [component setMonth:1];
    startDate = [calendar dateFromComponents:component];
    
    // Set end date of a year
    endDate = startDate;
    [component setDay:31];
    [component setMonth:12];
    endDate = [calendar dateFromComponents:component];
    
    //Set original frame of the label for calculating the position
    dateOriginFrame.origin.x = 122;
    dateOriginFrame.origin.y = 50;
    timeOriginFrame.origin.x = 100;
    timeOriginFrame.origin.y = 92;
    
    // Calculate number of days in a year for calculating
    component = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0];
    self.dateSlider.maximumValue = [component day];
    self.dateSlider.value = self.dateSlider.maximumValue/2;
    self.timeSlider.maximumValue = 48;
    self.timeSlider.value = 24;
    
    // set the thumb for the dateSlider at the begining
    component = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:currentDate options:0];
    self.dateSlider.value = component.day;
    dateFrame = dateOriginFrame;
    dateFrame.origin.x += (self.dateSlider.value/self.dateSlider.maximumValue)*212;
    [self.dateLabel removeFromSuperview];
    self.dateLabel.center = CGPointMake(round(dateFrame.origin.x)+0.5,round(dateFrame.origin.y)+0.5);
    [self addSubview:self.dateLabel];
    self.dateLabel.text = [dateFormatter stringFromDate:currentDate];
    
    // set the thumb for the timeSlider at the begining
    component = [calendar components:NSMinuteCalendarUnit fromDate:startTime toDate:currentTime options:0];
    self.timeSlider.value = (int)round(component.minute/30);
    timeFrame = timeOriginFrame;
    timeFrame.origin.x += (self.timeSlider.value/self.timeSlider.maximumValue)*212;
    [self.timeLabel removeFromSuperview];
    self.timeLabel.center = CGPointMake(round(timeFrame.origin.x)+0.5,round(timeFrame.origin.y)+0.5);
    component = [calendar components:NSIntegerMax fromDate:startTime];
    [component setMinute:(int)round(self.timeSlider.value)*30];
    currentTime = [calendar dateFromComponents:component];
    self.timeLabel.text = [timeFormatter stringFromDate:currentTime];
    [self addSubview:self.timeLabel];
    
    // set action for the slider
    [self.dateSlider addTarget:self action:@selector(dateSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.timeSlider addTarget:self action:@selector(timeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:dateSlider];
    [self addSubview:timeSlider];
    [self addSubview:dateLabel];
    [self addSubview:timeLabel];

}

-(void)dateSliderValueChanged:(UISlider*)paramSender{
    if ([paramSender isEqual:self.dateSlider]) {
        component = [calendar components:NSDayCalendarUnit fromDate:currentDate];
        component.day = (int)round(paramSender.value);
        currentDate = [calendar dateByAddingComponents:component toDate:startDate options:0];
        self.dateLabel.text = [dateFormatter stringFromDate:currentDate];
        dateFrame = dateOriginFrame;
        dateFrame.origin.x += (paramSender.value/self.dateSlider.maximumValue)*212;
        // if the label is ecceeded the screen, decre
        if (dateFrame.origin.x > 280) {
            dateFrame.origin.x -= 80;
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.dateLabel.center = CGPointMake(round(dateFrame.origin.x) + 0.5,round(dateFrame.origin.y)+0.5);
        [UIView commitAnimations];
        [moonSunCalc computeMoonriseAndMoonSet:currentTime withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        [moonSunCalc computeSunriseAndSunSet:currentTime withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        NSLog(@"curent date : %@",currentDate);
    }
}

-(void)timeSliderValueChanged:(UISlider*)paramSender{
    if ([paramSender isEqual:self.timeSlider]) {
        component.minute = (int)round(paramSender.value) * 30;
        currentTime = [calendar dateByAddingComponents:component toDate:startTime options:0];
        self.timeLabel.text = [timeFormatter stringFromDate:currentTime];
        timeFrame = timeOriginFrame;
        timeFrame.origin.x += (paramSender.value/self.timeSlider.maximumValue)*212;
        if (timeFrame.origin.x > 300) {
            timeFrame.origin.x -= 45;
        }
        NSLog(@"current time : %@",currentTime);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.timeLabel.center = CGPointMake(round(timeFrame.origin.x)+0.5,round(timeFrame.origin.y)+0.5);
        [UIView commitAnimations];
        [moonSunCalc computeMoonriseAndMoonSet:currentTime withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        [moonSunCalc computeSunriseAndSunSet:currentTime withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        
    }
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    imageViewYou.hidden = NO;
//    UITouch *aTouch = [[event allTouches]anyObject];
//    CGPoint pointLocation = [aTouch locationInView:self.mapViewController];
//    locationPointYou = pointLocation;
//    NSLog(@"location x = %f, location y = %f",pointLocation.x,pointLocation.y);
//    [self setNeedsDisplay];
//    
//}

//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"x1 = %f, y1 = %f, x2 = %f, y2 = %f",locationPointYou.x,locationPointYou.y,locationPointCenter.x, locationPointCenter.y);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextSetLineWidth(context, 2.0);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 200, 200);
//    CGContextStrokePath(context);
//}

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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date = [dateFormatter dateFromString:@"2013-05-01 9:44:00"];
    
    CenterAnnotationView * centerAnnotationView = nil;
    if ([annotation isKindOfClass:[CenterAnnotation class]]) {
        static NSString *idfr = @"center";
        centerAnnotationView = (CenterAnnotationView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:idfr];
        if (centerAnnotationView == nil) {
            centerAnnotationView = [[CenterAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:idfr withDate:date withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
        }
        return centerAnnotationView;
    }
    annotationView = nil;
    if ([annotation isKindOfClass:[AnnotationPoint class]]) {
        static NSString *identifier = @"AnnotationView";
        annotationView = (AnnotationPointView *)[self.mapViewController dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            
            annotationView = [[AnnotationPointView alloc]initWithAnnotation:annotation reuseIdentifier:identifier withDate:date withLatitude:coordinate2D.latitude withLongitude:coordinate2D.longitude];
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
