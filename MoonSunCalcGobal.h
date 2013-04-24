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
@property (nonatomic, retain) PositionEntity *positionEntity;
- (void)getDate;
- (void)computeMoonriseAndMoonSet:(PositionEntity *)position;
- (void)computeSunriseAndSunSet:(PositionEntity *)position;
- (void)computeAngleOfSunPointWithNorth:(int)hourRise withMinuteRise:(int)minuteRise withhousrSet:(int)hourSet withMinuteSet:(int)minuteSet withRiseAz:(float)riseAZ withSetAz:(float)setAZ withTimeCompute:(float)timeCompute;
- (void)computeAngleOfMoonPointWithNorth:(int)hourRise withMinuteRise:(int)minuteRise withhousrSet:(int)hourSet withMinuteSet:(int)minuteSet withRiseAz:(float)riseAZ withSetAz:(float)setAZ withTimeCompute:(float)timeCompute;

- (SunPosition *) getSunPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng ;
- (NSDictionary*)getSunTimesWithDate:(NSDate*)date andLatitude:(double)lat andLogitude:(double)lng ;
- (double )getSunAzimuthWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng ;
- (void)computePointInCricle:(float)azumith withRiseOrSet:(int)riseOrSet;
- (void) setSunPositionWithTime:(SunPosition *)sunPostion;


@end
