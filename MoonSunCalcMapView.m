//
//  MoonSunCalcMapView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/15/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MoonSunCalcMapView.h"
#import "ViewMove.h"

@implementation MoonSunCalcMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, 37, 48)];
        [self addSubview:cameraView];
        cameraView.hidden = YES;
    }
    return self;
}


- (void)drawRect:(MKMapRect)rect
{
    CGContextRef contextMoonRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonRise, [UIColor cyanColor].CGColor);
    CGContextSetLineWidth(contextMoonRise, 2.0);
    CGContextMoveToPoint(contextMoonRise, 103, 103);
    CGContextAddLineToPoint(contextMoonRise, 300,400);
    CGContextStrokePath(contextMoonRise);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    cameraView.center = location;
    cameraView.hidden = NO;
    NSValue *value = [NSValue valueWithCGPoint:location];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePointYou" object:value];
}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef contextMoonRise = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(contextMoonRise, [UIColor cyanColor].CGColor);
//    CGContextSetLineWidth(contextMoonRise, 2.0);
//    CGContextMoveToPoint(contextMoonRise, 103, 103);
//    CGContextAddLineToPoint(contextMoonRise, 300,400);
//    CGContextStrokePath(contextMoonRise);
//}


@end
