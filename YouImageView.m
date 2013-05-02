//
//  YouImageView.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/25/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "YouImageView.h"

@implementation YouImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *youImage = [UIImage imageNamed:@"icon_you@2x.png"];
        self.frame = CGRectMake(0 , 0, 25, 32);
        self.image = youImage;

        // Initialization code
    }
    return self;
}



@end
