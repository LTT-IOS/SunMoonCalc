//
//  MainViewController.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/7/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
@interface MainViewController : UIViewController<CustomSliderDelegate,UISearchBarDelegate>
{
    NSDateFormatter *dateFormatter;
    NSMutableData *dataPlace;
    NSMutableArray *arrayPlaceEntity;
    UISearchBar *searchBarPlace;
    
}
@property(nonatomic, strong) CustomSlider *dateSlider;
@property(nonatomic, strong) CustomSlider *timeSlider;
@property(nonatomic, strong) NSString *timeString;
@property(nonatomic, strong) NSString *dateString;
@end
