//
//  UIMovableLabel.h
//  DateTimeSlider
//
//  Created by Viet Ta Quoc on 4/25/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    UNIT_DAYS_IN_YEAR = NSYearCalendarUnit,
    UNIT_MINUTES_IN_DAY = NSIntegerMax,
} UNIT_FLAG;
@interface UIMovableLabel : UILabel
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *currentDate;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSDateComponents *component;
@property (nonatomic) CGRect originFrame;
@property (nonatomic) float factor;
-(void)reDraw:(CGRect)frame;
-(void)initDate:(NSUInteger)unitFlags withFctor:(float)factorValue byCalendar:(NSCalendar *)calendar withDateStyle:(NSString *)dateStyle;
-(void)updatePosition:(float)sliderValue withMaxValue:(float)maxValue withFlag:(NSUInteger)flag withSliderWidth:(float)sliderWidth byCalendar:(NSCalendar *)calendar;
@end
