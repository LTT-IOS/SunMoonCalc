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
#import "AnnotationPoint.h"

@interface AnnotationPointView : MKAnnotationView{
    
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPointImageView ;

    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPointImageView ;
    BOOL SunRiseSelect;

}
@property (nonatomic, strong)AnnotationPoint *annotationPoint;
@property (nonatomic, strong) NSDate *dateCompute;
@property (nonatomic, strong) CLLocation *locationCompute;
@property BOOL SunRiseSelect;
@property (weak) PositionEntity *position;
@property (nonatomic, strong) MoonSunCalcGobal *moonSucCalc;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng ;
- (void)updateContentView;

@end
