//
//  CityController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/8/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "CityController.h"
#import "CoreDataController.h"
#import "ProvinceController.h"

#import "Province.h"
#import "City.h"
//#import "County.h"

@implementation CityController

+ (id)sharedInstance {
    static CityController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * insert city to province
 */

- (void)insertCity:(NSArray *)array toProvince:(NSUInteger)provinceID {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[CoreDataController shareInstance] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"cityCode", @"cityName", nil];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // before adding the province, first check if there's a duplicate in the backing store
    NSError *error = nil;
    Province *province = [[ProvinceController sharedInstance] fetchProvinceWithCode:provinceID];
    for (NSDictionary *dict in array) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cityCode ==%@ OR cityName ==%@", dict[@"id"], dict[@"name"]];
        
        NSArray *fetchItems = [context executeFetchRequest:fetchRequest error:&error];
        //NSLog(@"%lu %@", (unsigned long)[fetchItems count], fetchItems);
        if (fetchItems.count == 0) {
            City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
            city.cityCode = dict[@"id"];
            city.cityName = dict[@"name"];
            
            [province addCitiesObject:city];
        }
    }

    [[CoreDataController shareInstance] saveContext];
}

- (NSArray *)fetchCityFromProvince:(Province *)province {
    NSArray *cityArray = province.cities.allObjects;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityCode.intValue" ascending:YES];
    
    NSArray *array = @[sortDescriptor];
    return [cityArray sortedArrayUsingDescriptors:array];
    //return cityArray;
}

- (City *)fetchCityWithName:(NSString *)name {
    City *city = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName ==%@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *citys = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([citys count] > 0) {
        city = [citys objectAtIndex:0];
    }
    return city;
}

- (City *)fetchCityWithCode:(NSString *)code {
    City *city = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityCode ==%@", code];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *citys = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([citys count] > 0) {
        city = [citys objectAtIndex:0];
    }
    return city;
}

@end
