//
//  ShareLocation.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/17/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "ShareLocation.h"
@class ShareLocation;

@interface ShareLocation ()

@end

@implementation ShareLocation
@synthesize userLocation,locationManager;

static ShareLocation *shareInstance;



#pragma mark - iLifecycle methods

+(ShareLocation *) shareMyInstance;
{
	@synchronized([ShareLocation class])
	{
		if (!shareInstance)
            shareInstance = [[self alloc] init] ;
        
		return shareInstance;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([ShareLocation class])
	{
		NSAssert(shareInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		shareInstance = [super alloc];
		return shareInstance;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        userLocation = [[CLLocation alloc]init];
	}
    
	return self;
}

+(id)userLocation{
    return self.userLocation;
}

-(void)startUpdate{
    
    [self.locationManager startUpdatingLocation];
//    [self.locationManager startUpdatingHeading];
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateHeading" object:newHeading];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if (userLocation) {
        userLocation = nil;
    }
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:userLocation.coordinate.latitude forKey:@"userLatitude"];
    [userDefault setFloat:userLocation.coordinate.longitude forKey:@"userLongitude"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLocation" object:newLocation];
}
-(CLLocation *) getOldLocation{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    float latitude = (float)[userDefault floatForKey:@"userLatitude"];
    float longitude = (float)[userDefault floatForKey:@"userLongitude"];
    
    CLLocation *oldLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    return oldLocation;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Update location fail");
}


@end
