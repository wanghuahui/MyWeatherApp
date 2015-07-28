//
//  ProvinceController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/2/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "ProvinceController.h"
#import "CoreDataController.h"
#import "Province.h"

@implementation ProvinceController

+ (id)sharedInstance {
    static ProvinceController *provinceInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provinceInstance = [[self alloc] init];
    });
    return provinceInstance;
}

- (NSArray *)fetchProvinces {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Province" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSError *error = nil;
    NSArray *provinces = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return provinces;
}

- (Province *)fetchProvinceWithName:(NSString *)name {
    Province *province = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Province" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"provinceName ==%@", name];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *provinces = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
   
    if ([provinces count] > 0) {
        province = [provinces objectAtIndex:0];
    }
    return province;
    
}

- (Province *)fetchProvinceWithCode:(NSUInteger)code {
    Province *province = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Province" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"provinceID ==%d", code];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *provinces = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([provinces count] > 0) {
        province = [provinces objectAtIndex:0];
    }
    return province;
}

- (void)clearAllProvinces {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Province" inManagedObjectContext:[[CoreDataController shareInstance] managedObjectContext]]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error = NULL;
    NSArray *provinces = [[[CoreDataController shareInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *province in provinces) {
        [[[CoreDataController shareInstance] managedObjectContext] deleteObject:province];
    }
    
    [[CoreDataController shareInstance] saveContext];
}

- (void)insertProvince:(NSArray *)array {
    //[self clearAllProvinces];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[CoreDataController shareInstance] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Province" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"provinceID", @"provinceName", nil];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // before adding the province, first check if there's a duplicate in the backing store
    NSError *error = nil;
    for (NSDictionary *dict in array) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"provinceID ==%@ OR provinceName ==%@", dict[@"id"], dict[@"name"]];
        
        NSArray *fetchItems = [context executeFetchRequest:fetchRequest error:&error];
        //NSLog(@"%lu %@", (unsigned long)[fetchItems count], fetchItems);
        //Province *pro = [fetchItems objectAtIndex:0];
        if (fetchItems.count == 0) {
            Province *province = [NSEntityDescription insertNewObjectForEntityForName:@"Province" inManagedObjectContext:context];
            province.provinceID = [NSNumber numberWithInt:[dict[@"id"] intValue]];
            province.provinceName = dict[@"name"];
        }
        
    }
    
    [[CoreDataController shareInstance] saveContext];
}

@end
