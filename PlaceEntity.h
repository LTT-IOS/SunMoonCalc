//
//  PlaceEntity.h
//  GoogleAPISSearchText
//
//  Created by Duc Long on 5/8/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceEntity : NSObject{
    
}
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSString *placeIconLink;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeType;
@property (nonatomic, strong) NSString *placeReference;

@property float placeRate;
@property float placeLatitude;
@property float placeLongitude;
- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
