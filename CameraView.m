//
//  CameraView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *youImage = [UIImage imageNamed:@"icon_you@2x.png"];
        youImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 47)];
        youImageView.image = youImage;
        [self addSubview:youImageView];
        // Initialization code
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [[event allTouches]anyObject];
    CGPoint pointLocation = [aTouch locationInView:self.superview];
    [self setCenter:pointLocation];
    CGPoint location = [aTouch locationInView:self.superview];
    CGPoint point;
    point.x = location.x;
    point.y = location.y - 20;
    NSValue *value = [NSValue valueWithCGPoint:point];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePointCamera" object:value];
}

@end
