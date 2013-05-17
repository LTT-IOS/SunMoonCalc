//
//  MainViewController.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/7/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import <MapKit/MapKit.h>
#import "AnnotationPoint.h"
#import "PositionEntity.h"
#import "MoonSunCalcGobal.h"
#import <CoreLocation/CoreLocation.h>
#import "AnnotationPointView.h"
#import "CenterAnnotation.h"
#import "MoonSunCalcMapView.h"
#import "CameraView.h"
#import "YouAnnotation.h"
#import "YouAnnotationView.h"
@interface MainViewController : UIViewController<CustomSliderDelegate,UISearchBarDelegate,MKMapViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSMutableData *dataPlace;
    NSMutableArray *arrayPlaceEntity;
    UISearchBar *searchBarPlace;
    
    UIImageView *youPointImageView ;
    CGPoint locationPointCenter;
    CGPoint locationPointYou;
    CLLocation *userLocation;
    CameraView *imageViewYou;
    AnnotationPointView *annotationView;
    CenterAnnotation *centerAnnotation;
    YouAnnotation *youAnnotation;
    YouAnnotationView *youAnnotationView;
    BOOL hiddenAnnotation;
    CLLocationCoordinate2D coordinate2D;
    CLLocationCoordinate2D coorYou;
    CLLocationCoordinate2D coorCenter;
    MKPolyline *line;
    CLLocationCoordinate2D *plotLocation;
    CameraView *cameraView;
    BOOL isMoveCenter;
    BOOL isFistTouches;
    
}
@property(nonatomic, strong) CustomSlider *dateSlider;
@property(nonatomic, strong) CustomSlider *timeSlider;
@property(nonatomic, strong) NSString *timeString;
@property(nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) AnnotationPointView *annotationView;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) MoonSunCalcMapView *mapViewController;
@property (nonatomic, strong)AnnotationPoint *annotationPoint;
@property (nonatomic, strong) PositionEntity *positionEntity;
@end
