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
#import "CenterAnnotation.h"
#import "YouImageView.h"

@class MoonSunCalcGobal;
@interface MapView : UIView<MKMapViewDelegate,UIGestureRecognizerDelegate>{
    UIImageView *youPointImageView ;
    CGPoint locationPointCenter;
    CGPoint locationPointYou;
    CLLocation *userLocation;
    YouImageView *imageViewYou;
    AnnotationPointView *annotationView;
    CenterAnnotation *centerAnnotation;
    BOOL hiddenAnnotation;
    CLLocationCoordinate2D coordinate2D;

}

@property (nonatomic, retain) AnnotationPointView *annotationView;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) MKMapView *mapViewController;
@property (nonatomic, retain)AnnotationPoint *annotationPoint;
@property (nonatomic, retain) PositionEntity *positionEntity;
@end
