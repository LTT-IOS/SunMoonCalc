//
//  CustomSlider.m
//  DateTimeSlider
//
//  Created by Viet Ta Quoc on 4/26/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import "CustomSlider.h"
#import "UIMovableLabel.h"

@implementation CustomSlider
@synthesize timeString;
@synthesize label;
@synthesize unitFlag,delegate;
NSCalendar *calendar;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initSliderWith:(NSUInteger)unitFlags withFactor:(float)factorValue withDateStyle:(NSString *)dateStyle{    

    
    calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    CGRect sliderFrame = CGRectMake(self.frame.origin.x + 55, self.frame.origin.y-8, 73, 21);
    label = [[UIMovableLabel alloc]initWithFrame:sliderFrame];
    [label initDate:unitFlags withFctor:factorValue byCalendar:calendar withDateStyle:dateStyle];
    if (unitFlags == UNIT_DAYS_IN_YEAR) {
        unitFlags = NSDayCalendarUnit;
        self.maximumValue = DAY_IN_A_YEAR([label.component year])/factorValue;
    } else {
        unitFlags = NSMinuteCalendarUnit;
        self.maximumValue = MINUTES_IN_A_DAY/factorValue;
    }
    label.component = [calendar components:unitFlags fromDate:label.startDate toDate:label.currentDate options:0];
    switch (unitFlags) {
        case NSDayCalendarUnit:
            self.value = (int)round(label.component.day/factorValue);
            label.component = [calendar components:unitFlags fromDate:label.startDate];
            [label.component setDay:(int)round(self.value*factorValue)];
            label.currentDate = [calendar dateFromComponents:label.component];
            label.text = [label.formatter stringFromDate:label.currentDate];
            unitFlag = NSDayCalendarUnit;
            break;
        case NSMinuteCalendarUnit:
            self.value = (int)round(label.component.minute/factorValue);
            label.component = [calendar components:unitFlags fromDate:label.startDate];
            [label.component setMinute:(int)round(self.value*factorValue)];
            label.currentDate = [calendar dateFromComponents:label.component];
            label.text = [label.formatter stringFromDate:label.currentDate];
            unitFlag = NSIntegerMax;
            break;
        default:
            break;
    }
    [label removeFromSuperview];
    [label updatePosition:self.value withMaxValue:self.maximumValue withFlag:unitFlags withSliderWidth:(self.frame.size.width-22) byCalendar:calendar];
    [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

}

-(void)sliderValueChanged:(CustomSlider*)paramSender{
    [self.label updatePosition:paramSender.value withMaxValue:self.maximumValue withFlag:unitFlag withSliderWidth:(self.frame.size.width-22) byCalendar:calendar];
    timeString = paramSender.label.text;
    
    [self updateValueString:paramSender withValueString:timeString];

}

- (void)updateValueString:(CustomSlider *)customSlider withValueString:(NSString *)valueString
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeValue:withValueString:)]) {
        [self.delegate didChangeValue:customSlider withValueString:valueString];
    }
}

@end
