//
//  WeatherParse.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/22/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherParse : NSObject

@property (strong, nonatomic) NSMutableArray *basicArray;  // 天气基本信息
@property (strong, nonatomic) NSMutableArray *envirArray;  // 环境信息
@property (strong, nonatomic) NSMutableArray *alarmArray;  // 天气预警信息
@property (strong, nonatomic) NSMutableArray *forecastArray;

+ (id)sharedInstance;

- (void)parseWeatherURL:(NSString *)weatherURL;

@end
