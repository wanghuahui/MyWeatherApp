//
//  Province.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/28/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Province : NSManagedObject

@property (nonatomic, retain) NSNumber * provinceID;
@property (nonatomic, retain) NSString * provinceName;
@property (nonatomic, retain) NSSet *cities;
@end

@interface Province (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(City *)value;
- (void)removeCitiesObject:(City *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;

@end
