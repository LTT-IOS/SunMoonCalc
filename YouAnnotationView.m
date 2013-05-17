//
//  YouAnnotation.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/17/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "YouAnnotationView.h"

@implementation YouAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withLatitude:(double)lat withLongitude:(double)lng;
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 38, 47);
        youImage = [UIImage imageNamed:@"icon_you@2x.png"];
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
    youImageView.frame = CGRectMake(0, 0, 38, 47);
    CGPoint location = [aTouch locationInView:self.window];
    CGPoint point;
    point.x = location.x;
    point.y = location.y - 20;
    NSValue *value = [NSValue valueWithCGPoint:point];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePointCamera" object:value];
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
