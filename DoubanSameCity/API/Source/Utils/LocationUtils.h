//
//  LocationUtils.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
    Get_Place = 0,
    Get_Altitude
}LocationType;

@interface LocationUtils : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (assign, nonatomic) double distance;                      //移动多少距离开始重新定位、
//@property (assign, nonatomic) double desiredAccuracy;               /*精确度，精度越大越耗电(可自定义，也有可选的值
//                                                                     kCLLocationAccuracyBest;
//                                                                     kCLLocationAccuracyNearestTenMeters;
//                                                                     kCLLocationAccuracyHundredMeters;
//                                                                     kCLLocationAccuracyKilometer;
//                                                                     kCLLocationAccuracyThreeKilometers)*/
@property (assign, nonatomic) double latitude;                      //维度
@property (assign, nonatomic) double longtitude;                    //经度
@property (assign, nonatomic) double altitude;                      //海拔
@property (assign, nonatomic) double horizontalAccuracy;            //水平准确度
@property (assign, nonatomic) double verticalAccuracy;              //垂直准确度

@property (strong, nonatomic) NSString *placeName;                  //位置名
@property (strong, nonatomic) NSString *thoraoughfare;              //街道
@property (strong, nonatomic) NSString *subThoroughfare;            //子街道
@property (strong, nonatomic) NSString *locality;                   //市
@property (strong, nonatomic) NSString *subLocality;                //区
@property (strong, nonatomic) NSString *country;                    //国家

@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) CLPlacemark *placeInfomation;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) CLLocation *currentLocation;

- (CLPlacemark *)getPlaceInfomation;
+ (CLPlacemark *)getPlaceInfomation:(NSString *)latitude longtitude:(NSString *)longtitude;
- (CLLocationCoordinate2D)getlatitude_longitude;
+ (CLLocationCoordinate2D)getlatitude_longitude:(NSString *)placeName;
- (CLLocation*)getCurrentLocation;

- (instancetype)init:(LocationType)type;
- (instancetype)init:(double)distance desiredAccuracy:(double)desiredAccuracy type:(LocationType)type;


- (void)initLocationManager;//就是这个 和后面的那个代理！！！！！！！！！！！！！！！在外面走的很好 里面就不行


@end
