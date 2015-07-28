//
//  CountyController.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/9/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City, County;

@interface CountyController : NSObject

+ (id)sharedInstance;

- (void)insertCounty:(NSArray *)array toCity:(NSString *)cityCode;

- (NSArray *)fetchCountyFromCity:(City *)city;

- (County *)fetchCountyWithName:(NSString *)name;

@end
