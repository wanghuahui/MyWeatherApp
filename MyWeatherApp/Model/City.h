//
//  City.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/30/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class County, Province;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * cityCode;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) Province *province;
@property (nonatomic, retain) NSSet *counties;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addCountiesObject:(County *)value;
- (void)removeCountiesObject:(County *)value;
- (void)addCounties:(NSSet *)values;
- (void)removeCounties:(NSSet *)values;

@end
