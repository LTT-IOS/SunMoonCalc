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
@property (nonatomic ,retain)NSDate *timeRiseSun;
@property (nonatomic, retain)NSDate *timeSetSun;
@property (nonatomic ,retain)NSDate *timeRiseMoon;
@property (nonatomic, retain)NSDate *timeSetMoon;
@property (nonatomic, retain) PositionEntity *positionEntity;
- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;


@end
