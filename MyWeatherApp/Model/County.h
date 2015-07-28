//
//  County.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/11/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface County : NSManagedObject

@property (nonatomic, retain) NSString * countyCode;
@property (nonatomic, retain) NSString * countyName;
@property (nonatomic, retain) NSString * weatherCode;
@property (nonatomic, retain) City *city;

@end
