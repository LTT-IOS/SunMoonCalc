//
//  MapView.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AnnotationPoint.h"
#import "PositionEntity.h"
#import "MoonSunCalcGobal.h"
#import <CoreLocation/CoreLocation.h>
#import "AnnotationPointView.h"
@class MoonSunCalcGobal;
@interface MapView : UIView<MKMapViewDelegate>{
    UIImageView *youPointImageView ;
    CGPoint locationPoint;
    CGPoint location;
    CLLocation *userLocation;
    AnnotationPointView *annotationView;

}
@property BOOL SunRiseSelect;
@property (nonatomic, retain) AnnotationPointView *annotationView;
@property (nonatomic, retain) CLLocation *userLocation;

@property (nonatomic, retain) MKMapView *mapViewController;
@property (nonatomic, retain)AnnotationPoint *annotationPoint;
@property (nonatomic, retain) PositionEntity *positionEntity;
@property (nonatomic, retain) MoonSunCalcGobal *moonSunCalc;
@end
