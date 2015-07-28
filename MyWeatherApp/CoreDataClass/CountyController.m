//
//  CountyController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/9/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "CountyController.h"
#import "CoreDataController.h"
#import "CityController.h"
#import "City.h"
#import "County.h"

@implementation CountyController

+ (id)sharedInstance {
    static CountyController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)insertCounty:(NSArray *)array toCity:(NSString *)cityCode {
    NSManagedObjectContext *context = [[CoreDataController shareInstance] managedObjectContext];
    City *city = [[CityController sharedInstance] fetchCityWithCode:cityCode];
    
    for (NSDictionary *dict in array) {
        County *county = [NSEntityDescription insertNewObjectForEntityForName:@"County" inManagedObjectContext:context];
        county.countyCode = dict[@"id"];
        county.countyName = dict[@"name"];
        county.weatherCode = dict[@"weatherCode"];
        
        [city addCountiesObject:county];
    }
    
    [[CoreDataController shareInstance] saveContext];
}

- (NSArray *)fetchCountyFromCity:(City *)city {
    NSArray *countyArray = city.counties.allObjects; //province.cities.allObjects;
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityCode.intValue" ascending:YES];
    
    //NSArray *array = @[sortDescriptor];
    //return [cityArray sortedArrayUsingDescriptors:array];
    return countyArray;
}

- (County *)fetchCountyWithName:(NSString *)name {
    County *county = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"County" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countyName ==%@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *countys = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([countys count] > 0) {
        county = [countys objectAtIndex:0];
    }
    return county;
}


@end
