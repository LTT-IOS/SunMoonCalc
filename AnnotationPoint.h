//
//  AnnotationPoint.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationPoint : NSObject<MKAnnotation>{
    NSString *name;
    CLLocationCoordinate2D coordinate;
    BOOL HiddenSunRise;
    BOOL HiddenSunSet;
    BOOL HiddenSunPoint;

}
@property BOOL HiddenSunRise;
@property BOOL HiddenSunSet;
@property BOOL HiddenSunPoint;

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation;

@end
