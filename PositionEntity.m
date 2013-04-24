//
//  PositionEntity.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "PositionEntity.h"

@implementation PositionEntity
@synthesize latitude,longitude,day,month,year,locationX,locationY,pointMoonRiseX,pointMoonRiseY,pointMoonSetX,pointMoonSetY, pointMoonX, pointMoonY,pointSunRiseX, pointSunRiseY, pointSunSetX,pointSunSetY ,pointSunX,pointSunY ,azimuthMoonRise,azimuthMoonSet,azimuthSunRise,azimuthSunSet,hourMoonRise,hourMoonSet,minuteMoonRise,minuteMoonSet,hourSunRise,hourSunSet,minuteSunRise,minuteSunSet;

- (id)initWithLatitude:(float)userLatitude longitude:(float)userLongitude withDay:(int)daySelected withMonth:(int)monthSelected withYear:(int)yearSeleted{
    self = [super init];
    if (self) {
        self.latitude = userLatitude;
        self.longitude = userLongitude;
        self.day = daySelected;
        self.month = monthSelected;
        self.year = yearSeleted;       
    }
    return  self;
}

@end
