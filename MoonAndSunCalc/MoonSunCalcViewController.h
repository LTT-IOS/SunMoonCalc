//
//  MoonSunCalcViewController.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoonSunCalcViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIView) UIView *ViewXib;
@property (nonatomic,strong) IBOutlet UISlider *dateSlider;
@property (nonatomic,strong) IBOutlet UISlider *timeSlider;
@property (nonatomic,strong) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@end
