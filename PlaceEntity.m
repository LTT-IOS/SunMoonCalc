//
//  PlaceEntity.m
//  GoogleAPISSearchText
//
//  Created by Duc Long on 5/8/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "PlaceEntity.h"
#import "Utility.h"

@implementation PlaceEntity
@synthesize placeAddress,placeIconLink,placeID,placeLatitude,placeLongitude,placeName,placeRate,placeReference,placeType;

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.placeAddress = [dictionary objectForKey:PlaceProperiesPlaceAddress];
        self.placeLatitude = [[dictionary objectForKey:PlaceProperiesPlaceLatitude]floatValue];
        self.placeLongitude = [[dictionary objectForKey:PlaceProperiesPlaceLongitude]floatValue];
    }
    return  self;
}

@end
