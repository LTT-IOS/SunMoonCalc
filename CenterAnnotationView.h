//
//  CenterAnnotationView.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/24/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CenterAnnotationView : MKAnnotationView{
    UIImageView *imageViewCenter;
    UIImage *image;
    UIImage *imageCenter;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
@end
