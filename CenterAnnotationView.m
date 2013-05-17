//
//  CenterAnnotationView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/24/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "CenterAnnotationView.h"

@implementation CenterAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.frame = CGRectMake(0, 0, 36, 56);
        image = [UIImage imageNamed:@"icon_pin_did_Click@2x.png"];
        imageCenter = [UIImage imageNamed:@"icon_pin@2x.png"];
        imageViewCenter = [[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 13, 23)];
        imageViewCenter.image = imageCenter;
        [self addSubview:imageViewCenter];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [[event allTouches]anyObject];
    CGPoint pointLocation = [aTouch locationInView:self.superview];
    [self setCenter:pointLocation];
    imageViewCenter.frame = CGRectMake(12, -9, 13, 33);
    imageViewCenter.image = image;
    CGPoint location = [aTouch locationInView:self.window];
    CGPoint point;
    point.x = location.x;
    point.y = location.y - 20;
    NSValue *value = [NSValue valueWithCGPoint:point];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePoint" object:value];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    imageViewCenter.frame = CGRectMake(12, 5, 13, 23);
    imageViewCenter.image = imageCenter;
}
@end
