//
//  LocationUtils.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "LocationUtils.h"

@implementation LocationUtils
- (instancetype)init:(NSInteger)type{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 300;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
        self.type = type;

    }
    return self;
}

- (instancetype)init:(double)distance desiredAccuracy:(double)desiredAccuracy type:(NSInteger)type{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = distance;
        self.locationManager.desiredAccuracy = desiredAccuracy;
        [self.locationManager startUpdatingLocation];
        self.type = type;
    }
    return self;
}




- (CLPlacemark *)getPlaceInfomation{
    return self.placeInfomation;
}

//+ (CLPlacemark *)getPlaceInfomation:(NSString *)latitude longtitude:(NSString *)longtitude{
//    
//}
//- (CLLocationCoordinate2D)getlatitude_longitude;
//+ (CLLocationCoordinate2D)getlatitude_longitude:(NSString *)placeName;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    switch (self.type) {
        case 1:
        {
            CLLocation *currentLocation = [locations lastObject];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder  reverseGeocodeLocation:currentLocation completionHandler:^(NSArray
                                                                                  *placemarks, NSError *error) {
                for (CLPlacemark *place in placemarks)
                {
                    self.placeInfomation = place;
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
@end
