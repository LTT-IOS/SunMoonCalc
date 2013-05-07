//
//  MoonSunCalcViewController.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MoonSunCalcViewController.h"
#import "MapView.h"
#import "CustomSlider.h"

@implementation MoonSunCalcViewController
@synthesize dateSlider,timeSlider;
- (void)viewDidLoad
{
    [super viewDidLoad];

 //   MapView *mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
//    [self.view addSubview:mapView];
 //   [self.view sendSubviewToBack:mapView];
    self.view.backgroundColor = [UIColor whiteColor];
    dateSlider = [[CustomSlider alloc]initWithFrame:CGRectMake(0, 0, 249, 23)];
//    [dateSlider initSliderWith:UNIT_DAYS_IN_YEAR withFactor:1 withDateStyle:@"yyyy/MM/dd"];
//    [timeSlider initSliderWith:UNIT_MINUTES_IN_DAY withFactor:30 withDateStyle:@"HH:mm"];
//    dateSlider.label.frame = CGRectMake(5, 50, 73, 21);
//    timeSlider.label.frame = CGRectMake(5, 200, 73, 21);
//    [self.view addSubview:dateSlider.label];
//    [self.view bringSubviewToFront:dateSlider.label];
//    NSLog(@"gia tri :%@",timeSlider.label);
    NSLog(@"slider = %@",dateSlider);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

//    [self setViewXib:nil];
    [super viewDidUnload];
}
@end
