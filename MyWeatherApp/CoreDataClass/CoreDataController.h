//
//  CoreDataController.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/28/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)shareInstance;
- (void)saveContext;

@end
