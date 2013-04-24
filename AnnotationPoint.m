//
//  AnnotationPoint.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "AnnotationPoint.h"

@implementation AnnotationPoint
@synthesize name,coordinate,HiddenSunRise,HiddenSunPoint,HiddenSunSet;
-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation{
    if (self=[super init]) {
        self.name = nameAnnotation;
        self.coordinate = coordinateAnnotation;
    }
    return self;
    
}
@end
