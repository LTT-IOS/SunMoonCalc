//
//  CustomSlider.h
//  DateTimeSlider
//
//  Created by Viet Ta Quoc on 4/26/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMovableLabel.h"
#import "CustomSlider.h"
@class CustomSlider;
#define MINUTES_IN_A_DAY 1440
#define DAY_IN_A_YEAR(year) (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 365 : 364

@protocol CustomSliderDelegate <NSObject>

@optional
- (void)didChangeValue:(CustomSlider *)customSlider withValueString:(NSString *)valueString;
@end

@interface CustomSlider : UISlider
{
}
@property (nonatomic, strong) id<CustomSliderDelegate>delegate;
@property (nonatomic) NSUInteger unitFlag;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic,strong) IBOutlet UIMovableLabel *label;
-(void)initSliderWith:(NSUInteger)unitFlags withFactor:(float)factorValue withDateStyle:(NSString *)dateStyle;
@end
