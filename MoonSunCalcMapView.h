//
//  MoonSunCalcMapView.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/15/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CameraView.h"

@interface MoonSunCalcMapView : MKMapView{
    CameraView *cameraView;
}

@end
