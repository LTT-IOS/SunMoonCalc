//
//  ShareLocation.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/17/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ShareLocation : NSObject<CLLocationManagerDelegate>{
    CLLocation *userLocation ;
    CLLocationManager *locationManager;
}
@property(nonatomic,strong) CLLocation *userLocation ;
@property(nonatomic,strong) CLLocationManager *locationManager;
+ (ShareLocation *)shareMyInstance;
- (CLLocation *)getOldLocation;
-(void)startUpdate;

@end