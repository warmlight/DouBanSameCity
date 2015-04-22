//
//  LocationUtils.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "LocationUtils.h"
#import <UIKit/UIKit.h>

static LocationUtils *locationUtils = nil;
@implementation LocationUtils

+ (LocationUtils *)shareInstance{
    if (locationUtils == nil) {
        locationUtils = [locationUtils init];
    }else{
        return locationUtils;
    }
    return locationUtils;
}

- (void)starLocation:(double)distance desiredAccuracy:(double)desiredAccuracy type:(LocationType)type delegate:(id)delegate{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 300;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];//ios8要添加 还要在plist里添加
    }
    [self.locationManager startUpdatingLocation];
    self.type = 0;
}

- (instancetype)init:(LocationType)type{
    self = [super init];
    if (self) {
        if([CLLocationManager locationServicesEnabled]){
            self.locationManager = [[CLLocationManager alloc] init];            
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = 300;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                [self.locationManager requestWhenInUseAuthorization];//ios8要添加 还要在plist里添加
            }
            [self.locationManager startUpdatingLocation];
            self.type = type;
        }
    }
    return self;
}

- (instancetype)init:(double)distance desiredAccuracy:(double)desiredAccuracy type:(LocationType)type{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = distance;
        self.locationManager.desiredAccuracy = desiredAccuracy;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        self.type = type;
    }
    return self;
}

- (CLPlacemark *)getPlaceInfomation{
    return self.placeInfomation;
}

- (CLLocationCoordinate2D)getlatitude_longitude{
    return self.coordinate;
}

- (CLLocation *)getCurrentLocation{
    return self.currentLocation;
}

//+ (CLPlacemark *)getPlaceInfomation:(NSString *)latitude longtitude:(NSString *)longtitude{
//    
//}
//- (CLLocationCoordinate2D)getlatitude_longitude;
//+ (CLLocationCoordinate2D)getlatitude_longitude:(NSString *)placeName;

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    switch (self.type) {
//        case 0:
//        {
//            CLLocation *currentLocation = [locations lastObject];
//            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//            [geocoder  reverseGeocodeLocation:currentLocation completionHandler:^(NSArray
//                                                                                  *placemarks, NSError *error) {
//                for (CLPlacemark *place in placemarks)
//                {
//                    self.placeInfomation = place;
//                    [manager stopUpdatingLocation];
//                }
//            }];
//        }
//            break;
//        case 1:
//        {
//            CLLocation *currentLocation = [locations lastObject];
//            CLLocationCoordinate2D coordinate = currentLocation.coordinate;
//            self.coordinate = coordinate;
//            self.currentLocation = currentLocation;
//            [manager stopUpdatingLocation];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
- (void)initLocationManager{
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 300;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [self.locationManager requestWhenInUseAuthorization];//ios8要添加 还要在plist里添加
        }
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder  reverseGeocodeLocation:currentLocation completionHandler:^(NSArray
                                                                          *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks)
        {
            NSLog(@"name,%@",place.name);
            NSLog(@"thoroughfare,%@",place.thoroughfare);
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);
            NSLog(@"locality,%@",place.locality);
            NSLog(@"subLocality,%@",place.subLocality);
            NSLog(@"country,%@",place.country);
            [manager stopUpdatingLocation];
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

@end
