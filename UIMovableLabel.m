//
//  UIMovableLabel.m
//  DateTimeSlider
//
//  Created by Viet Ta Quoc on 4/25/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import "UIMovableLabel.h"
#define RIGHT_BOUND 280
#define MINUS_BOUND 10
#define ANIMATION_DURATION 0.2

@implementation UIMovableLabel
@synthesize startDate;
@synthesize currentDate;
@synthesize formatter;
@synthesize component;
@synthesize originFrame;
@synthesize factor;
CGRect currentFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        originFrame = frame;
        [self setBackgroundColor:[UIColor clearColor]];
        self.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

-(void)initDate:(NSUInteger)unitFlags withFctor:(float)factorValue byCalendar:(NSCalendar *)calendar withDateStyle:(NSString *)dateStyle{
    startDate = [NSDate date];
    currentDate = [NSDate date];
    component = [[NSDateComponents alloc] init];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateStyle];
    factor = factorValue;

    //set the start point
    component = [calendar components:unitFlags fromDate:startDate];
    [component setHour:0];
    [component setMinute:0];
    [component setSecond:0];
    startDate = [calendar dateFromComponents:component];
}

-(void)reDraw:(CGRect)frame{
    if (frame.origin.x > RIGHT_BOUND) {
        frame.origin.x -= self.frame.size.width + MINUS_BOUND;
        self.textAlignment = NSTextAlignmentRight;
    } else {
        self.textAlignment = NSTextAlignmentLeft;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    self.center = CGPointMake(round(frame.origin.x)+0.5,round(frame.origin.y)+0.5);
    [UIView commitAnimations];
}

-(void)updatePosition:(float)sliderValue withMaxValue:(float)maxValue withFlag:(NSUInteger)flag withSliderWidth:(float)sliderWidth byCalendar:(NSCalendar *)calendar{
    switch (flag) {
        case NSDayCalendarUnit:
            component.day = (int)round(sliderValue)*factor;
            break;
        case NSIntegerMax:
            component = [calendar components:flag fromDate:startDate];
            component.minute = (int)round(sliderValue) * factor;
            break;
        default:
            break;
    }
    currentDate = [calendar dateByAddingComponents:component toDate:startDate options:0];
    self.text = [formatter stringFromDate:currentDate];
    
    currentFrame = self.originFrame;
    currentFrame.origin.x += (sliderValue/maxValue)*sliderWidth;
    [self reDraw:currentFrame];
}
@end
