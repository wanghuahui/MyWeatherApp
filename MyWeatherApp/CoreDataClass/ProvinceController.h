//
//  ProvinceController.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/2/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Province;

@interface ProvinceController : NSObject

+ (id)sharedInstance;

- (void)clearAllProvinces;

- (NSArray *)fetchProvinces;

- (Province *)fetchProvinceWithName:(NSString *)name;

- (Province *)fetchProvinceWithCode:(NSUInteger)code;

- (void)insertProvince:(NSArray *)array;

@end
