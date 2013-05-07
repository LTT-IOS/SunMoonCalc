//
//  MoonSunCalcViewController.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"

@interface MoonSunCalcViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIView) UIView *ViewXib;
@property (nonatomic,strong) CustomSlider *dateSlider;
@property (nonatomic,strong) CustomSlider *timeSlider;
@end
