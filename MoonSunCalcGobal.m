//
//  MoonSunCalcGobal.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/11/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//
#import "SunCoordinate.h"
#import "SunPosition.h"
#import "MoonSunCalcGobal.h"
#import "MoonCoordinate.h"
#import "MoonPosition.h"
#define MoonSetSelected 0
#define MoonRiseSelected 1
#define SunSetSelected 3
#define SunRiseSelected 4
#define MoonPoint 9
#define SunPoint 6
double DR = M_PI/180.0;
double K1 = 15 * M_PI/180.0 * 1.0027379 ;
double SkyM[3] = {0.0,0.0,0.0} ;
double RAnM[3] = {0.0,0.0,0.0};
double DecM[3] = {0.0,0.0,0.0};
double VHzM[3] = {0.0,0.0,0.0};
int Rise_timeM[2] = {0 , 0};
int Set_timeM[2] = {0,0};
double Rise_azM = 0.0;
double Set_azM = 0.0;
BOOL MoonRise ;
BOOL MoonSet ;

double SkyS[3] = {0.0,0.0,0.0} ;
double RAnS[3] = {0.0,0.0,0.0};
double DecS[3] = {0.0,0.0,0.0};
double VHzS[3] = {0.0,0.0,0.0};
int Rise_timeS[2] = {0 , 0};
int Set_timeS[2] = {0,0};
double Rise_azS = 0.0;
double Set_azS = 0.0;
double timeSunRiseLocation;
double timeSunSetLocation;

BOOL Sunrise = NO;
BOOL SunSet = NO;

@implementation MoonSunCalcGobal
@synthesize dayNow,monthNow,yearNow,timeRiseSun,timeSetSun,timeRiseMoon,timeSetMoon;
@synthesize pointRiseX,pointRiseY,pointSetX,pointSetY;
@synthesize positionEntity;
- (id)init
{
    self = [super init];
    if (self) {
        positionEntity = [[PositionEntity alloc]init];
    }
    return self;
}
#pragma mark - getposition Sun
- (double)getSolarMeanAnomalyWithDayNumber:(double)d {
    return DR * (357.5291 + 0.98560028 * d);
}

- (double)getEquationOfCenterWithSolarMean:(double)M {
    return DR * (1.9148 * sin(M) + 0.02 * sin(2*M) + 0.0003 * sin(3*M));
}

- (double)getEclipticLongitudeWithSolarMean:(double)M andCenter:(double)C {
    double P = DR * 102.9372; // điểm cận nhật của trái đất.
    return M + C + P + M_PI;
}

- (double)e{
    return DR * 23.4397;//obliquity(do nghieng) of the Earth
}
- (double)getDeclinationWithLongitude:(double)l andLatitude:(double)b {
    return asin(sin(b) * cos(self.e) + cos(b) * sin(self.e) *sin(l));
}

- (double)getRightAscensionWithLongitude:(double)l andLatitude:(double)b {
    return atan2(sin(l) * cos(self.e) - tan(b) * sin(self.e), cos(l));
}


- (double)secondInDay {
    return 60*60*24 ;
}
- (double)J1970 {
    return 2440588;
}
- (double)J2000 {
    return 2451545;
}
- (double) toJulian:(NSDate*)date {
    return (date.timeIntervalSince1970 )/ self.secondInDay - 0.5 + self.J1970;
}

- (double)toDays:(NSDate*)date {
    double d = [self toJulian:date] - self.J2000;
    return d;
}

- (double)getSiderealTimeWithDayNumber:(double)d andObserverLongitude:(double)lw{
    return DR * (280.16 + 360.9856235 * d) - lw;
}

- (double)getAzimuthWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec {
    return M_PI + atan2(sin(H), cos(H)*sin(phi) - tan(dec) * cos(phi));

}

- (double)getAltitudeWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec {
    return asin(sin(phi)*sin(dec) + cos(phi)*cos(dec)*cos(H));
}

- (SunCoordinate*)getSunCoordsWithDayNumber:(double)julianDay {
    double M = [self getSolarMeanAnomalyWithDayNumber:julianDay];
    double C = [self getEquationOfCenterWithSolarMean:M];
    double L = [self getEclipticLongitudeWithSolarMean:M andCenter:C];
    SunCoordinate *coor = [[SunCoordinate alloc]initWithDeclination:[self getDeclinationWithLongitude:L andLatitude:0] andRightAscension:[self getRightAscensionWithLongitude:L andLatitude:0]];
    return coor;
}
- (void )getSunPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng {
    double lw = DR * (-lng);
    double phi = DR * lat;
    double d = [self toDays:date];
    SunCoordinate * c = [[SunCoordinate alloc]init ];
    c = [self getSunCoordsWithDayNumber:d];
    
    double H = [self getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    
    SunPosition *pos = [[SunPosition alloc]initWithAzimuth:[self getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination] andAltitude:[self getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination]];
    [self setSunPositionWithTime:pos withDate:date];

}

- (void) setSunPositionWithTime:(SunPosition *)sunPostion withDate:(NSDate *)date
{
//    NSLog(@"time rise : %@ ,now = %@, time set : %@",timeRiseSun,date,timeSetSun);

//    if ((([date compare:timeRiseSun]== NSOrderedAscending)||([date compare:timeSetSun]== NSOrderedDescending)) ) {
//        positionEntity.pointSunX = 103;
//        positionEntity.pointSunY = 103;
    
        if ((!Sunrise)&&(!SunSet))                 // neither sunrise nor sunset
        {
            if (VHzS[2] < 0){
                positionEntity.pointSunX = 103;
                positionEntity.pointSunY = 103;
            }
            else{
                double angle =  sunPostion.azimuth - M_PI_2;
                float x = 103 + 100 *cos(angle)*cos(sunPostion.altitude);
                float y = 103 + 100 *sin(angle)*cos(sunPostion.altitude);
                positionEntity.pointSunX = x;
                positionEntity.pointSunY = y;
            }
            
        }
        else if ((!Sunrise)||(!SunSet))                                    // sunrise or sunset
        {
            if (!Sunrise) {
                if ([timeSetSun compare:date] == NSOrderedAscending) {
                    positionEntity.pointSunX = 103;
                    positionEntity.pointSunY = 103;
                }
                else {
                    double angle =  sunPostion.azimuth - M_PI_2;
                    float x = 103 + 100 *cos(angle)*cos(sunPostion.altitude);
                    float y = 103 + 100 *sin(angle)*cos(sunPostion.altitude);
                    positionEntity.pointSunX = x;
                    positionEntity.pointSunY = y;
                }
                
            }
            else
            {
                if ([date compare:timeRiseSun] == NSOrderedAscending) {
                    positionEntity.pointSunX = 103;
                    positionEntity.pointSunY = 103;
                }
                else {
                double angle =  sunPostion.azimuth - M_PI_2;
                float x = 103 + 100 *cos(angle)*cos(sunPostion.altitude);
                float y = 103 + 100 *sin(angle)*cos(sunPostion.altitude);
                positionEntity.pointSunX = x;
                positionEntity.pointSunY = y;
                }
            }
   
        }
    

    else if ((Sunrise) && (SunSet)) {
        if ((([date compare:timeRiseSun]== NSOrderedAscending)||([date compare:timeSetSun]== NSOrderedDescending)) ) {
            positionEntity.pointSunX = 103;
            positionEntity.pointSunY = 103;
        }
        else{
            double angle =  sunPostion.azimuth - M_PI_2;
            float x = 103 + 100 *cos(angle)*cos(sunPostion.altitude);
            float y = 103 + 100 *sin(angle)*cos(sunPostion.altitude);
            positionEntity.pointSunX = x;
            positionEntity.pointSunY = y;
        }

    }

}

#pragma mark - get point Moon
-(MoonCoordinate *)getMoonCoords:(double)julianday { // geocentric ecliptic coordinates of the moon
    
    double L = DR * (218.316 + 13.176396 * julianday), // ecliptic longitude
    M = DR * (134.963 + 13.064993 * julianday), // mean anomaly
    F = DR * (93.272 + 13.229350 * julianday), // mean distance
    
    l = L + DR * 6.289 * sin(M), // longitude
    b = DR * 5.128 * sin(F), // latitude
    dt = 385001 - 20905 * cos(M); // distance to the moon in km
    MoonCoordinate *moonCoor = [[MoonCoordinate alloc]initWithDeclination:[self getDeclinationWithLongitude:l andLatitude:b] andRightAscension:[self getRightAscensionWithLongitude:l andLatitude:b] andDistance:dt];
    return moonCoor;
}

- (MoonPosition *) getMoonPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng wihtBool:(BOOL)moonRiseBig{

    double lw = DR * -lng;
    double phi = DR * lat;
    double d = [self toDays:date];
    
    MoonCoordinate *c = [self getMoonCoords:d];
    double H = [self getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    double h = [self getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination];
    
    // altitude correction for refraction
    h = h + DR * 0.017 / tan(h + DR * 10.26 / (h + DR * 5.10));
    MoonPosition *moonPos = [[MoonPosition alloc]initWithAzimuth:[self getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination] andAltitude:h andDistance:c.distance];
//    NSLog(@"azimuth = %f,altitude = %f,distance = %f",moonPos.azimuth,moonPos.altitude,moonPos.distance);
    [self setMoonPositionWithTime:moonPos withDate:date withbool:moonRiseBig];
    return moonPos;
    
}


- (void) setMoonPositionWithTime:(MoonPosition *)moonPostion withDate:(NSDate *)date withbool:(BOOL)moonRiseBig
{
    NSLog(@"time rise : %@ ,now = %@, time set : %@",timeRiseMoon,date,timeSetMoon);
    if ((!MoonRise)&&(!MoonSet))                 // neither sunrise nor sunset
    {
        if (VHzM[2] < 0){
            positionEntity.pointMoonX = 103;
            positionEntity.pointMoonY = 103;
        }
        else if (VHzM[2] >= 0){
            double angle =  moonPostion.azimuth - M_PI_2;
            float x = 103 + 100 *cos(angle)*cos(moonPostion.altitude);
            float y = 103 + 100 *sin(angle)*cos(moonPostion.altitude);
            positionEntity.pointMoonX = x;
            positionEntity.pointMoonY = y;
        }
    }
    
    else if ((!MoonRise)||(!MoonSet))                                    // sunrise or sunset
    {
        if (!MoonRise) {
            if (([date compare:timeSetMoon]== NSOrderedDescending) ) {
                positionEntity.pointMoonX = 103;
                positionEntity.pointMoonY = 103;
            }
            else
            {
                double angle =  moonPostion.azimuth - M_PI_2;
                float x = 103 + 100 *cos(angle)*cos(moonPostion.altitude);
                float y = 103 + 100 *sin(angle)*cos(moonPostion.altitude);
                positionEntity.pointMoonX = x;
                positionEntity.pointMoonY = y;
            }
        }
        else if(!MoonSet) {
            if ([date compare:timeRiseMoon]== NSOrderedAscending) {
                positionEntity.pointMoonX = 103;
                positionEntity.pointMoonY = 103;
            }
            else {
                double angle =  moonPostion.azimuth - M_PI_2;
                float x = 103 + 100 *cos(angle)*cos(moonPostion.altitude);
                float y = 103 + 100 *sin(angle)*cos(moonPostion.altitude);
                positionEntity.pointMoonX = x;
                positionEntity.pointMoonY = y;
                
            }
        }
    }
        
    else if((MoonRise) && (MoonSet)){
            if (moonRiseBig == YES) {
                if ((([date compare:timeRiseMoon]== NSOrderedAscending)&&([date compare:timeSetMoon]== NSOrderedDescending)) ) {
                    positionEntity.pointMoonX = 103;
                    positionEntity.pointMoonY = 103;
                }
                else {
                    double angle =  moonPostion.azimuth - M_PI_2;
                    float x = 103 + 100 *cos(angle)*cos(moonPostion.altitude);
                    float y = 103 + 100 *sin(angle)*cos(moonPostion.altitude);
                    positionEntity.pointMoonX = x;
                    positionEntity.pointMoonY = y;
                }
            }
            else {
                if ((([date compare:timeRiseMoon]== NSOrderedAscending)||([date compare:timeSetMoon]== NSOrderedDescending)) ) {
                    positionEntity.pointMoonX = 103;
                    positionEntity.pointMoonY = 103;
                }
                else {
                    double angle =  moonPostion.azimuth - M_PI_2;
                    float x = 103 + 100 *cos(angle)*cos(moonPostion.altitude);
                    float y = 103 + 100 *sin(angle)*cos(moonPostion.altitude);
                    positionEntity.pointMoonX = x;
                    positionEntity.pointMoonY = y;
                }
            }
        }
}
#pragma mark - compute point Rise and Set in Cricle of moon and sun

- (void)computePointInCricle:(float)azumith withRiseOrSet:(int)riseOrSet{
    if (azumith == 0.0) {
        if (riseOrSet == MoonSetSelected) {
            positionEntity.pointMoonSetX = 103;
            positionEntity.pointMoonSetY = 103;
        }
        else if (riseOrSet == MoonRiseSelected){
            positionEntity.pointMoonRiseX = 103;
            positionEntity.pointMoonRiseY = 103;
        }
        else if (riseOrSet == SunSetSelected){
            positionEntity.pointSunSetX = 103;
            positionEntity.pointSunSetY = 103;
        }
        else if (riseOrSet == SunRiseSelected){
            positionEntity.pointSunRiseX = 103;
            positionEntity.pointSunRiseY = 103;
        }
        else if (riseOrSet == MoonPoint){
            if (VHzM[2] < 0) {
                positionEntity.pointMoonX = 103;
                positionEntity.pointMoonY = 103;
            }

        }
        else if (riseOrSet == SunPoint){
            if (VHzS[2] < 0) {
                positionEntity.pointSunX = 103;
                positionEntity.pointSunY = 103;
            }
        }
            
    }
    else {
        
        azumith = (azumith * M_PI )/ 180.0;
        float a = 0.0;
        if (0 <  azumith <= M_PI_2) {
            a = tanf(M_PI_2 + azumith );
        }
        else if (M_PI_2 < azumith <= 3 * M_PI_2) {
            a = tanf(azumith - M_PI_2);
        }
        
        else{
            a = tanf(azumith - 3 * M_PI_2);
        }
        
        float b = 103 - 103 * a;
        float indexA = 1 + a * a;
        float indexB = 2 * a * b - 206 * a - 206 ;
        float indexC = b * b - 206 * b + 11218;
        float originX = [self giaiPhuongTrinhB2:indexA withIndexB:indexB withIndexC:indexC withAngle:azumith];
        float originY = a * originX + b;
        if (riseOrSet == MoonSetSelected) {
            positionEntity.pointMoonSetX = originX;
            positionEntity.pointMoonSetY = originY;
        }
        else if (riseOrSet == MoonRiseSelected){
            positionEntity.pointMoonRiseX = originX;
            positionEntity.pointMoonRiseY = originY;
        }
        else if (riseOrSet == SunSetSelected){
            positionEntity.pointSunSetX = originX;
            positionEntity.pointSunSetY = originY;
        }
        else if (riseOrSet == SunRiseSelected){
            positionEntity.pointSunRiseX = originX;
            positionEntity.pointSunRiseY = originY;
        }
        else if (riseOrSet == MoonPoint){
            positionEntity.pointMoonX = originX;
            positionEntity.pointMoonY = originY;
        }
        else if (riseOrSet == SunPoint){
            positionEntity.pointSunX = originX;
            positionEntity.pointSunY = originY;
        
        }
    }
    
}

- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle
{
    float x;
    float delta = (b * b) - ( 4 * a * c );
    float x1;
    float x2;
    x1 = (- b +  (sqrtf(delta))) / (2 * a);
    x2 = (- b -  (sqrtf(delta))) / (2 * a);
    if ((0 < angle && angle <= M_PI) ||( - 2 * M_PI < angle && angle < -M_PI)) {
        x = MAX(x1, x2);
    }
    else {
        x = MIN(x1, x2);
    }
    return x;
    
}


#pragma mark - compute moonrise and moon set

- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng{
    NSLog(@"lat = %f, long = %f",lat,lng);
    Rise_azM = 0.0;
    Set_azM = 0.0;
    Rise_timeM[0] = 0.0;
    Rise_timeM[1] = 0.0;
    Set_timeM[0] = 0.0;
    Set_timeM[1] = 0.0;
    VHzM[2] = 0.0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    double timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:date] / 3600.0;
    double x = lng;
    double zone = round(-x/15.0);
    NSLog(@"zone = %f",zone);
    NSDate *dateCompute = [NSDate dateWithTimeInterval:-(zone + timeZoneOffset)*60*60 sinceDate:date];
    NSDate *dateC1 = [NSDate dateWithTimeInterval:-(timeZoneOffset*60*60) sinceDate:dateCompute];

    NSString *day = [self conVertDateToStringDay:dateC1];
    int dayValue = [day intValue];
    NSString *month = [self conVertDateToStringMonth:dateC1];
    int monthValue = [month intValue];
    NSString *year = [self conVertDateToStringYear:dateC1];
    int yearValue = [year intValue];
    
    double jd = [self julian_day:yearValue withMonth:monthValue withDay:dayValue] - 2451545.0;
    
    double mp[3][3] = {0.0,0.0,0.0,0.0,0.0,0.0};
    
    float longitude = lng/360.0;
    
    double tz = zone / 24.0;

    double t0 = [self lst:longitude withJday:jd withZ:tz];
    
    jd = jd + tz;
    
    for (int k = 0; k < 3; k ++) {
        [self moon:jd];
        mp[k][0] = SkyM[0];
        mp[k][1] = SkyM[1];
        mp[k][2] = SkyM[2];
        jd = jd + 0.5;
    }
    
    if (mp[1][0] <= mp[0][0]){
        mp[1][0] = mp[1][0] + 2 * M_PI;
    }
    
    if (mp[2][0] <= mp[1][0]){
        mp[2][0] = mp[2][0] + 2 * M_PI;
    }
    
    RAnM[0] = mp[0][0];
    DecM[0] = mp[0][1];
    double ph = 0.0;
    MoonRise = NO;
    MoonSet = NO;
    
    for (int k = 0; k < 24; k++)                   // check each hour of this day
    {
        ph = (k + 1)/24.0;
        RAnM[2] = [self interpolate:mp[0][0] withf1:mp[1][0] withf2:mp[2][0] withp:ph];
        DecM[2] = [self interpolate:mp[0][1] withf1:mp[1][1] withf2:mp[2][1] withp:ph];
        VHzM[2] = [self test_moon:k withZone:zone witht0:t0 withLat:lat withPlx:mp[1][2]];
        RAnM[0] = RAnM[2];                       // advance to next hour
        DecM[0] = DecM[2];
        VHzM[0] = VHzM[2];
    }
    
    NSString *dateStringRise = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,[NSString stringWithFormat:@"%d",Rise_timeM[0]],[NSString stringWithFormat:@"%d",Rise_timeM[1]]];
    NSDate *dateMoonRise = [dateFormatter dateFromString:dateStringRise];
        timeRiseMoon = [NSDate dateWithTimeInterval:(zone)*60*60 sinceDate:dateMoonRise];
        
    NSString *dateStringSet = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,[NSString stringWithFormat:@"%d",Set_timeM[0]],[NSString stringWithFormat:@"%d",Set_timeM[1]]];
    NSDate *dateMoonSet = [dateFormatter dateFromString:dateStringSet];
        timeSetMoon = [NSDate dateWithTimeInterval:(zone)*60*60 sinceDate:dateMoonSet];
    NSDate *dateC = [NSDate dateWithTimeInterval:zone*60*60 sinceDate:dateCompute];

    
    if ([timeRiseMoon compare:timeSetMoon] == NSOrderedDescending) {
        [self getMoonPositionWithDate:dateC andLatitude:lat andLongitude:lng wihtBool:YES];

    }
    else
    {
        [self getMoonPositionWithDate:dateC andLatitude:lat andLongitude:lng wihtBool:NO];
    }
    
    if (MoonRise == YES) {
        [self computePointInCricle:Rise_azM withRiseOrSet:MoonRiseSelected];
    }
    else {
        positionEntity.pointMoonRiseX = 103;
        positionEntity.pointMoonRiseY = 103;
    }
    if (MoonSet == YES) {
        [self computePointInCricle:Set_azM withRiseOrSet:MoonSetSelected];
    }
    else
    {
        positionEntity.pointMoonSetX = 103;
        positionEntity.pointMoonSetY = 103;
    }
}


- (double)test_moon :(double)k withZone:(double)zone witht0:(double)t0 withLat:(double)lat withPlx:(double)plx
{
    double ha[3] = {0.0, 0.0, 0.0};
    double a, b, c, d, e, s, z;
    double hr, min, time;
    double az, hz, nz, dz;
    
    if (RAnM[2] < RAnM[0]){
        RAnM[2] = RAnM[2] + 2 * M_PI;
    }
    
    ha[0] = t0 - RAnM[0] + k * K1;
    ha[2] = t0 - RAnM[2] + k*K1 + K1;
    ha[1]  = (ha[2] + ha[0])/2.0;                // hour angle at half hour
    
    DecM[1] = (DecM[2] + DecM[0])/2.0;              // declination at half hour
    
    s = sin(DR*lat);
    c = cos(DR*lat);
    
    // refraction + sun semidiameter at horizon + parallax correction
    z = cos(DR*(90.567 - 41.685/plx));
    
    if (k <= 0){                                // first call of function
        VHzM[0] = s*sin(DecM[0]) + c*cos(DecM[0])* cos(ha[0]) - z;
    }
    VHzM[2] = s*sin(DecM[2]) + c * cos(DecM[2])* cos(ha[2]) - z;
    
    
    if ([self sgn:VHzM[0]] == [self sgn:VHzM[2]]){
        return VHzM[2];                         // no event this hour
    }
    VHzM[1] = s*sin(DecM[1]) + c*cos(DecM[1])*cos(ha[1]) - z;
    
    a = 2*VHzM[2] - 4*VHzM[1] + 2*VHzM[0];
    b = 4*VHzM[1] - 3*VHzM[0] - VHzM[2];
    d = b*b - 4*a*VHzM[0];
    
    if (d < 0){
        return VHzM[2];                         // no event this hour
    }
    d = sqrt(d);
    e = (-b + d)/(2*a);
    
    if (( e > 1 )||( e < 0 )){
        e = (-b - d)/(2*a);
    }
    
    time = k + e + 1.0/120.0;                      // time of an event + round up
    hr   = floor(time);
    min  = floor((time - hr)*60);
    
    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the moon at the event
    nz = -cos(DecM[1])*sin(hz);
    dz = c*sin(DecM[1]) - s*cos(DecM[1])*cos(hz);
    az = atan2(nz, dz)/DR;
    if (az < 0){
        az = az + 360;
    }
    if ((VHzM[0] < 0)&&(VHzM[2] > 0))
    {
        Rise_timeM[0] = hr;
        Rise_timeM[1] = min;
        Rise_azM = az;
        MoonRise = YES;
    }
    
    if ((VHzM[0] > 0)&&(VHzM[2] < 0))
    {
        Set_timeM[0] = hr;
        Set_timeM[1] = min;
        Set_azM = az;
        MoonSet = YES;
    }
    return VHzM[2];
}


- (void)moon:(double )jd
{
    double d, f, g, h, m, n, s, u, v, w;
    
    h = 0.606434 + 0.03660110129*jd;
    m = 0.374897 + 0.03629164709*jd;
    f = 0.259091 + 0.0367481952 *jd;
    d = 0.827362 + 0.03386319198*jd;
    n = 0.347343 - 0.00014709391*jd;
    g = 0.993126 + 0.0027377785 *jd;
    
    h = h - floor(h);
    m = m - floor(m);
    f = f - floor(f);
    d = d - floor(d);
    n = n - floor(n);
    g = g - floor(g);
    
    h = h * 2 * M_PI;
    m = m * 2 * M_PI;
    f = f * 2 * M_PI;
    d = d * 2 * M_PI;
    n = n * 2 * M_PI;
    g = g * 2 * M_PI;
    
    v = 0.39558 * sin(f + n);
    v = v + 0.082  * sin(f);
    v = v + 0.03257 * sin(m - f - n);
    v = v + 0.01092 * sin(m + f + n);
    v = v + 0.00666 * sin(m - f);
    v = v - 0.00644 * sin(m + f - 2*d + n);
    v = v - 0.00331 * sin(f - 2*d + n);
    v = v - 0.00304 * sin(f - 2*d);
    v = v - 0.0024 * sin(m - f - 2*d - n);
    v = v + 0.00226 * sin(m + f);
    v = v - 0.00108 * sin(m + f - 2*d);
    v = v - 0.00079 * sin(f - n);
    v = v + 0.00078 * sin(f + 2*d + n);
    
    u = 1 - 0.10828 * cos(m);
    u = u - 0.0188 * cos(m - 2*d);
    u = u - 0.01479 * cos(2*d);
    u = u + 0.00181 * cos(2*m - 2*d);
    u = u - 0.00147 * cos(2*m);
    u = u - 0.00105 * cos(2*d - g);
    u = u - 0.00075 * cos(m - 2*d + g);
    
    w = 0.10478 * sin(m);
    w = w - 0.04105 * sin(2*f + 2*n);
    w = w - 0.0213 * sin(m - 2*d);
    w = w - 0.01779 * sin(2*f + n);
    w = w + 0.01774 * sin(n);
    w = w + 0.00987 * sin(2*d);
    w = w - 0.00338 * sin(m - 2*f - 2*n);
    w = w - 0.00309 * sin(g);
    w = w - 0.0019 * sin(2*f);
    w = w - 0.00144 * sin(m + n);
    w = w - 0.00144 * sin(m - 2*f - n);
    w = w - 0.00113 * sin(m + 2*f + 2*n);
    w = w - 0.00094 * sin(m - 2*d + g);
    w = w - 0.00092 * sin(2*m - 2*d);
    
    s = w/sqrt(u - v*v);
    // compute moon's right ascension ...
    SkyM[0] = h + atan(s/sqrt(1 - s*s));
    
    s = v/sqrt(u);                        // declination ...
    SkyM[1] = atan(s/sqrt(1 - s*s));
    
    SkyM[2] = 60.40974 * sqrt( u );          // and parallax
}


#pragma mark - compute Sun rise and Sun set

- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng
{
    Rise_azS = 0.0;
    Set_azS = 0.0;
    Rise_timeS[0] = 0.0;
    Rise_timeS[1] = 0.0;
    Set_timeS[0] = 0.0;
    Set_timeS[1] = 0.0;
    VHzS[2] = 0.0;
    timeSunRiseLocation = 0.0;
    timeSunSetLocation = 0.0;
//    NSLog(@"date = %@",date);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    double x = lng;
    double zone = round(-x/15.0);
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    double timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:date] / 3600.0;
    NSDate *dateCompute = [NSDate dateWithTimeInterval:-(zone + timeZoneOffset)*60*60 sinceDate:date];
    NSDate *dateC1 = [NSDate dateWithTimeInterval:-(timeZoneOffset*60*60) sinceDate:dateCompute];
    
    NSString *day = [self conVertDateToStringDay:dateC1];
    int dayValue = [day intValue]  ;
    NSString *month = [self conVertDateToStringMonth:dateC1];
    int monthValue = [month intValue];
    NSString *year = [self conVertDateToStringYear:dateC1];
    int yearValue = [year intValue];

    int k;
    double jd = [self julian_day:yearValue withMonth:monthValue withDay:dayValue] - 2451545.0;


    double longitude = lng /360.0;
    double tz  = zone /24.0;
    double ct  = jd/36525.0 + 1;                    // centuries since 1900.0
    double t0 = [self lst:longitude withJday:jd withZ:tz];
    jd = jd + tz;

    
    // get sun position at start of day
    [self sun:jd withCT:ct];
    float ra0  = SkyS[0];
    float dec0 = SkyS[1];
    jd = jd + 1.0;
    [self sun:jd withCT:ct]; // get sun position at end of day
    float ra1  = SkyS[0];
    float dec1 = SkyS[1];

    
    if (ra1 < ra0){                             // make continuous
        ra1 = ra1 + 2*M_PI;
    }
    Sunrise = NO;
    SunSet = NO;
    RAnS[0]   = ra0;
    DecS[0]  = dec0;
    
    for (k = 0; k < 24; k++)                   // check each hour of this day
    {
        RAnS[2] = ra0  + (k + 1)*(ra1  - ra0)/24.0;
        DecS[2] = dec0 + (k + 1)*(dec1 - dec0)/24.0;
        VHzS[2] = [self test_hour:k withZone:zone wihtT0:t0 withLat:lat];
        
        RAnS[0] = RAnS[2];                       // advance to next hour
        DecS[0] = DecS[2];
        VHzS[0] = VHzS[2];
    }
    

    
    NSString *dateStringRise = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,[NSString stringWithFormat:@"%d",Rise_timeS[0]],[NSString stringWithFormat:@"%d",Rise_timeS[1]]];
    NSDate *dateSunRise = [dateFormatter dateFromString:dateStringRise];

    timeRiseSun = [NSDate dateWithTimeInterval:zone*60*60 sinceDate:dateSunRise];
    NSString *dateStringSet = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,[NSString stringWithFormat:@"%d",Set_timeS[0]],[NSString stringWithFormat:@"%d",Set_timeS[1]]];
    NSDate *dateSunSet = [dateFormatter dateFromString:dateStringSet];
     timeSetSun = [NSDate dateWithTimeInterval:zone*60*60 sinceDate:dateSunSet];
    NSDate *dateC = [NSDate dateWithTimeInterval:zone*60*60 sinceDate:dateCompute];
    [self getSunPositionWithDate:dateC andLatitude:lat andLongitude:lng];

    if (Sunrise == YES) {

        [self computePointInCricle:Rise_azS withRiseOrSet:SunRiseSelected];
    }
    else{
        positionEntity.pointSunRiseX = 103;
        positionEntity.pointSunRiseY = 103;
    }
    if (SunSet == YES) {
        [self computePointInCricle:Set_azS withRiseOrSet:SunSetSelected];
    }
    else{
        positionEntity.pointSunSetX = 103;
        positionEntity.pointSunSetY = 103;
    }
}


-(double)test_hour:(double)k withZone:(double)zone wihtT0:(double)t0 withLat:(double)lat
{
    double ha[3] = {0.0, 0.0, 0.0};
    double a, b, c, d, e, s, z;
    double hr, min, time;
    double az, dz, hz, nz;
    
    ha[0] = t0 - RAnS[0] + k*K1;
    ha[2] = t0 - RAnS[2] + k*K1 + K1;
    
    ha[1]  = (ha[2]  + ha[0])/2.0;               // hour angle at half hour
    DecS[1] = (DecS[2] + DecS[0])/2.0 ;             // declination at half hour
    
    s = sin(lat*DR);
    c = cos(lat*DR);
    z = cos(90.833*DR);                   // refraction + sun semidiameter at horizon
    if (k <= 0)
        
        VHzS[0] = s*sin(DecS[0]) + c*cos(DecS[0])*cos(ha[0]) - z;
    
    VHzS[2] = s*sin(DecS[2]) + c*cos(DecS[2])*cos(ha[2]) - z;
    
    if ([self sgn:VHzS[0]] == [self sgn:VHzS[2]] ) {
        return VHzS[2];
    }
    if ([self sgn:VHzS[0]] == [self sgn:VHzS[2]] ){
        return VHzS[2];                         // no event this hour
    }
    VHzS[1] = s*sin(DecS[1]) + c*cos(DecS[1])*cos(ha[1]) - z;
    
    a =  2* VHzS[0] - 4*VHzS[1] + 2*VHzS[2];
    b = -3* VHzS[0] + 4*VHzS[1] - VHzS[2];
    d = b*b - 4*a*VHzS[0];
    
    if (d < 0)
        return VHzS[2];                         // no event this hour
    
    d = sqrt(d);
    e = (-b + d)/(2 * a);
    
    if ((e > 1)||(e < 0))
        e = (-b - d)/(2*a);
    
    time = k + e + 1/120.0;                      // time of an event
    
    hr = floor(time);
    min = floor((time - hr)*60.0);
    
    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the sun at the event
    nz = -cos(DecS[1])*sin(hz);
    dz = c*sin(DecS[1]) - s*cos(DecS[1])*cos(hz);
    az = atan2(nz, dz)/DR;
    if (az < 0) az = az + 360;
    
    if ((VHzS[0] < 0)&&(VHzS[2] > 0))
    {
        Rise_timeS[0] = hr;
        Rise_timeS[1] = min;
        Rise_azS = az;
        Sunrise = YES;
    }
    
    if ((VHzS[0] > 0)&&(VHzS[2] < 0))
    {
        Set_timeS[0] = hr;
        Set_timeS[1] = min;
        Set_azS = az;
        SunSet = YES;
    }
    
    return VHzS[2];
}


-(void) sun :(double)jd withCT:(double)ct
{
    double g, lo, s, u, v, w;
    
    lo = 0.779072 + 0.00273790931*jd;
    
    lo = lo - floor(lo);
    lo = lo*2* M_PI;
    
    g = 0.993126 + 0.0027377785*jd;
    g = g - floor(g);
    g = g*2*M_PI;
    
    v = 0.39785*sin(lo);
    v = v - 0.01*sin(lo - g);
    v = v + 0.00333*sin(lo + g);
    v = v - 0.00021*ct * sin(lo);
    
    u = 1 - 0.03349*cos(g);
    u = u - 0.00014*cos(2*lo);
    u = u + 0.00008*cos(lo);
    
    w = -0.0001 - 0.04129*sin(2*lo);
    w = w + 0.03211*sin(g );
    w = w + 0.00104*sin(2*lo - g);
    w = w - 0.00035*sin(2*lo + g);
    w = w - 0.00008*ct*sin(g);
    
    s = w/sqrt(u - v*v);                  // compute sun's right ascension
    SkyS[0] = lo + atan(s/sqrt(1 - s*s));
    
    s = v/sqrt(u);                        // ...and declination
    SkyS[1] = atan(s/sqrt(1 - s*s));
}

#pragma mark - function global

- (int)sgn:( double )x
{
    int rv;
    if (x > 0.0)      rv =  1;
    else if (x < 0.0) rv = -1;
    else              rv =  0;
    return rv;
}
- (double)interpolate:(double)f0 withf1:(double)f1 withf2:(double)f2 withp:(double)p
{
    double a = f1 - f0;
    double b = f2 - f1 - a;
    double f = f0 + p * ( 2*a + b * ( 2 * p - 1));
    return f;
}

- (double)lst :(double )longitude withJday:(double)jday withZ:(double)z
{
    double s = 24110.5 + 8640184.812999999 * jday / 36525 + 86636.6 * z + 86400 * longitude;
    s = s/86400.0;
    s = s - floor(s);
    s = s * 360.0 * DR;
    return s;
}

- (double)julian_day :(int)year withMonth:(int)month withDay:(int)day
{
    double a, b, jd;
    BOOL gregorian;
    month = month ;
    gregorian = (year < 1583) ? false : true;
    
    if ((month == 1)||(month == 2))
    {
        year  = year  - 1;
        month = month + 12;
    }
    
    a = floor(year/100.0) ;
    if (gregorian){
        b = 2 - a + floor(a/4.0);
    }
    else{
        b = 0.0;
    }
    jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + b - 1524.5;
    
    return jd;
}

#pragma mark - get date now

- (void)getDate
{
    NSDate *now = [NSDate date];
    NSString *day = [self conVertDateToStringDay:now];
    dayNow = [day intValue];
    NSString *month = [self conVertDateToStringMonth:now];
    monthNow = [month intValue];
    NSString *year = [self conVertDateToStringYear:now];
    yearNow = [year intValue];
}

-(NSString *)conVertDateToStringDay:(NSDate *)date
{
    NSDateFormatter *dfDay = [[NSDateFormatter alloc]init];
    [dfDay setDateFormat:@"dd"];
    NSString *dayString = [dfDay stringFromDate:date];
    return dayString;
}

-(NSString *)conVertDateToStringMonth:(NSDate *)date
{
    NSDateFormatter *dfMonth = [[NSDateFormatter alloc]init];
    [dfMonth setDateFormat:@"MM"];
    NSString *monthString = [dfMonth stringFromDate:date];
    return monthString;
}

-(NSString *)conVertDateToStringYear:(NSDate *)date
{
    NSDateFormatter *dfYear = [[NSDateFormatter alloc]init];
    [dfYear setDateFormat:@"yyyy"];
    NSString *yearString = [dfYear stringFromDate:date];
    return yearString;
}
-(NSString *)conVertDateToStringHour:(NSDate *)date
{
    NSDateFormatter *dfHour = [[NSDateFormatter alloc]init];
    [dfHour setDateFormat:@"HH"];
    NSString *hourString = [dfHour stringFromDate:date];
    return hourString;
}
-(NSString *)conVertDateToStringMinute:(NSDate *)date
{
    NSDateFormatter *dfMunite = [[NSDateFormatter alloc]init];
    [dfMunite setDateFormat:@"mm"];
    NSString *minuteString = [dfMunite stringFromDate:date];
    return minuteString;
}

@end
