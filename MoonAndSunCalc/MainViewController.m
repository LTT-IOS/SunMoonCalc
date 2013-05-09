//
//  MainViewController.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 5/7/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "MainViewController.h"
#import "MapView.h"
#import "JSON.h"
#import "Utility.h"
#import "PlaceEntity.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dateSlider,timeSlider,timeString,dateString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataPlace = [[NSMutableData alloc]init];
    arrayPlaceEntity = [[NSMutableArray alloc]init];
    UIBarButtonItem * buttonDone = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(didchangeTextSearchBar:)];
    self.navigationItem.rightBarButtonItem = buttonDone;
//    self.navigationController.navigationBarHidden = YES;
    
    searchBarPlace =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [searchBarPlace setDelegate:self];
    [self.view addSubview:searchBarPlace];

    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    MapView *mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 40, 320, 420)];
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    
    dateSlider = [[CustomSlider alloc]initWithFrame:CGRectMake(62, 400, 249, 23)];
    dateSlider.tag = 0;
    dateSlider.delegate = self;
    [dateSlider initSliderWith:UNIT_DAYS_IN_YEAR withFactor:1 withDateStyle:@"yyyy/MM/dd"];
    dateString = dateSlider.label.text;
    [self.view addSubview:dateSlider];
    [self.view addSubview:dateSlider.label];
    
    timeSlider = [[CustomSlider alloc]initWithFrame:CGRectMake(62, 430, 249, 23)];
    timeSlider.delegate = self;
    timeSlider.tag = 1;
    [timeSlider initSliderWith:UNIT_MINUTES_IN_DAY withFactor:30 withDateStyle:@"HH:mm"];
    timeString = timeSlider.label.text;
    [self.view addSubview:timeSlider];
    [self.view addSubview:timeSlider.label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}
- (void)didChangeValue:(CustomSlider *)customSlider withValueString:(NSString *)valueString
{
    if (customSlider.tag == 0) {
        dateString = valueString;
    }
    if (customSlider.tag == 1) {
        timeString = valueString;
    }
    NSString *currentDateString = [NSString stringWithFormat:@"%@ %@:00",dateString,timeString];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateDate" object:currentDate];
}

#pragma mark - get Data Place By Text

-(void)getPlaceDateWithText:(NSString*)textSearch{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=true&key=AIzaSyDjQt2mhVtMaLcjqtoC6ttU_y9e9K1iHb4",textSearch];
    NSLog(@"url : %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (urlConnection) {
        NSLog(@"connect");
    } else {
        NSLog(@"no connect");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSLog(@"respon : %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataPlace appendData:data];
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error is : %@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:dataPlace encoding:NSUTF8StringEncoding];
    NSDictionary *results = [responseString JSONValue];
    NSArray *arrayResults = [results objectForKey:@"results"];
    for (NSDictionary *dictPlace in arrayResults) {
        NSDictionary *dictGeometry = [dictPlace objectForKey:PlaceProperiesPlaceGeometry];
        
        NSDictionary *dictLocation = [dictGeometry objectForKey:PlaceProperiesPlaceLocation];
        NSString *latitude = [dictLocation objectForKey:PlaceProperiesPlaceLatitude];
        NSString *longitude = [dictLocation objectForKey:PlaceProperiesPlaceLongitude];
        NSString *placeAddress = [dictPlace objectForKey:PlaceProperiesPlaceAddress];
        
        NSMutableDictionary *place = [[NSMutableDictionary alloc]init];
        [place setObject:latitude forKey:PlaceProperiesPlaceLatitude];
        [place setObject:longitude forKey:PlaceProperiesPlaceLongitude];
        [place setObject:placeAddress forKey:PlaceProperiesPlaceAddress];
        PlaceEntity *placeEntity = [[PlaceEntity alloc]initWithDictionary:place];
        [arrayPlaceEntity addObject:placeEntity];
    }
    NSLog(@"results :%@",arrayResults);
}
#pragma mark - searchBar Delegate
- (void)didchangeTextSearchBar:(UISearchBar *)searchBar
{
    NSLog(@"text :%@",searchBarPlace.text);
    [self getPlaceDateWithText:searchBarPlace.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"hello");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
@end
