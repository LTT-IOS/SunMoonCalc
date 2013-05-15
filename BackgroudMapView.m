//
//  BackgroudMapView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "BackgroudMapView.h"
#import "ViewMove.h"
#import "CameraView.h"

@implementation BackgroudMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePoint:) name:@"UpdatePoint" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdatePointCamera:) name:@"UpdatePointCamera" object:nil];

        locationPointCenter.x = 160;
        locationPointCenter.y = 230 ;
        [self setBackgroundColor:[UIColor clearColor]];
        ViewMove *locationView = [[ViewMove alloc]initWithFrame:CGRectMake(160 - 6.5, 230 - 11.5, 26, 46)];
        [self addSubview:locationView];
        
        cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, 37, 48)];
        [self addSubview:cameraView];
        cameraView.hidden = YES;
        isMoveCenter = NO;
        MovePointYou = NO;
        isFist = NO;

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextYou = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextYou, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(contextYou, 2.0);
    if (MovePointYou == YES) {
        CGContextMoveToPoint(contextYou, locationPointCenter.x, locationPointCenter.y);
        CGContextAddLineToPoint(contextYou,locationPointYou.x,locationPointYou.y );
        CGContextStrokePath(contextYou);
    }
//    else
//    {
//        
//    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    MovePointYou = YES;
    if (isMoveCenter == NO) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:self];
        locationPointYou = location;
        cameraView.center = location;
        cameraView.hidden = NO;
        isFist = YES;
    }
    else
    {
        isMoveCenter = NO;

    }
    if (isFist == YES) {
        [self setNeedsDisplay];

    }
}

-(void)didUpdatePoint:(NSNotification *)notifi{
    isMoveCenter = YES;
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    locationPointCenter = point;
    MovePointYou = YES;

    if (isFist == YES) {
        [self setNeedsDisplay];
    }


}
-(void)didUpdatePointCamera:(NSNotification *)notifi{
    NSValue *value = (NSValue *)[notifi object];
    CGPoint point = [value CGPointValue];
    locationPointYou = point;
    MovePointYou = YES;
    [self setNeedsDisplay];
}
@end
