//
//  YouAnnotation.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/17/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface YouAnnotationView : MKAnnotationView{
    UIImageView *youImageView;
    UIImage *youImage;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withLatitude:(double)lat withLongitude:(double)lng;
@end
