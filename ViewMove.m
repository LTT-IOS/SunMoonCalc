//
//  ViewMove.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "ViewMove.h"

@implementation ViewMove

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imageCenterOn = [UIImage imageNamed:@"icon_pin_did_Click@2x.png"];
        imageCenterOff = [UIImage imageNamed:@"icon_pin@2x.png"];
        imageViewCenter = [[UIImageView alloc]initWithFrame:CGRectMake(3, -9, 13, 23)];
        imageViewCenter.image = imageCenterOff;
        [self addSubview:imageViewCenter];
        // Initialization code
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [[event allTouches]anyObject];
    CGPoint pointLocation = [aTouch locationInView:self.superview];
    [self setCenter:pointLocation];
    imageViewCenter.frame = CGRectMake(6,-9, 13, 33);
    imageViewCenter.image = imageCenterOn;
    CGPoint location = [aTouch locationInView:self.window];
    CGPoint point;
    point.x = location.x;
    point.y = location.y - 20;
    NSValue *value = [NSValue valueWithCGPoint:point];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePoint" object:value];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    imageViewCenter.frame = CGRectMake(6, 0, 13, 23);
    imageViewCenter.image = imageCenterOff;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
