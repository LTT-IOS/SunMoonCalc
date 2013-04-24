//
//  AnnotationPointView.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PositionEntity.h"
#import "MoonSunCalcGobal.h"

@interface AnnotationPointView : MKAnnotationView{
    
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPointImageView ;

    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPointImageView ;
    BOOL SunRiseSelect;

}
@property BOOL SunRiseSelect;
@property PositionEntity *position;

@property (nonatomic, retain) MoonSunCalcGobal *moonSucCalc;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withPosition:(PositionEntity *)postionEntity;

@end
