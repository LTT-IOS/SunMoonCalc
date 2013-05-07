//
//  MainViewController.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/7/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MainViewController.h"
#import "MapView.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dateSlider,timeSlider,timeString,dateString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    MapView *mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didChangeValue:(CustomSlider *)customSlider withValueString:(NSString *)valueString
{
    if (customSlider.tag == 0) {
        dateString = valueString;
    }
    if (customSlider.tag == 1) {
        timeString = valueString;
//        NSLog(@"gia tri time : %@",valueString);
    }

    
    NSString *currentDateString = [NSString stringWithFormat:@"%@ %@:00",dateString,timeString];
    
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
//    NSLog(@"date string:%@",currentDate);

    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateDate" object:currentDate];

}

@end
