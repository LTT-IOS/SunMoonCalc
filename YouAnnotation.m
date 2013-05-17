//
//  YouAnnotation.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/17/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "YouAnnotation.h"

@implementation YouAnnotation
@synthesize name,coordinate;
-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation{
    if (self=[super init]) {
        self.name = nameAnnotation;
        self.coordinate = coordinateAnnotation;
    }
    return self;
    
}

@end
