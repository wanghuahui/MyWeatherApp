//
//  CityController.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/8/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Province, City;

@interface CityController : NSObject

+ (id)sharedInstance;

- (void)insertCity:(NSArray *)array toProvince:(NSUInteger)provinceID;

- (NSArray *)fetchCityFromProvince:(Province *)province;
//- (NSArray *)fetchCountyFromCity:(City *)city;

- (City *)fetchCityWithName:(NSString *)name;
- (City *)fetchCityWithCode:(NSString *)code;

@end
