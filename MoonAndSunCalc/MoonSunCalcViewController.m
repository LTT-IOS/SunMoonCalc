//
//  MoonSunCalcViewController.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MoonSunCalcViewController.h"
#import "MapView.h"



@interface MoonSunCalcViewController (){
    double Rise_az ;
    double Set_az ;
}

@end

@implementation MoonSunCalcViewController

- (void)viewDidLoad
{
    MapView *mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:mapView];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
