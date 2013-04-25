//
//  CenterAnnotation.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/24/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CenterAnnotation : NSObject<MKAnnotation>{
    NSString *name;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation;

@end
