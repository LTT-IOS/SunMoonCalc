//
//  MoonSunCalcGobal.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/11/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionEntity.h"
#import "SunPosition.h"

@interface MoonSunCalcGobal : NSObject{
    
}
@property int dayNow,monthNow,yearNow;
@property float pointRiseX;
@property float pointRiseY;

@property float pointSetX;
@property float pointSetY;
@property (nonatomic ,retain)NSDate *timeRiseSun;
@property (nonatomic, retain)NSDate *timeSetSun;
@property (nonatomic, retain) PositionEntity *positionEntity;
- (void)getDate;
- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void ) getSunPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng ;


@end
