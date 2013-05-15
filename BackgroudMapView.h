//
//  BackgroudMapView.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraView.h"
@interface BackgroudMapView : UIView{
    CameraView *cameraView;
    CGPoint locationPointCenter;
    CGPoint locationPointYou;
    CGPoint locationPointTemp;
    BOOL MovePointYou;
    BOOL isMoveCenter;
    BOOL isFist;
}
@end
