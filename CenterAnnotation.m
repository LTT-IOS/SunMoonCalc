//
//  CenterAnnotation.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/24/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "CenterAnnotation.h"

@implementation CenterAnnotation
@synthesize name,coordinate;
-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation{
    if (self=[super init]) {
        self.name = nameAnnotation;
        self.coordinate = coordinateAnnotation;
    }
    return self;
    
}
@end
