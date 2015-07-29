//
//  AppDelegate.m
//  NMBottomTabBarControllerExample
//
//  Created by Prianka Liz Kariat on 05/12/14.
//  Copyright (c) 2014 Prianka Liz. All rights reserved.
//

#import "AppDelegate.h"
#import "CCKFNavDrawer.h"
#import "NMBottomTabBarController.h"
#import "WeatherTableViewController.h"
#import "ForecastViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:4];
    NSArray *storyArray = @[@"Weather", @"Forecast"];
    [storyArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {  // 遍历数组
        UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
        UIViewController *vc = [sb instantiateInitialViewController];
        [controllers addObject:vc];
    }];
    
    UIViewController *threeController = [UIViewController new];
    threeController.view.backgroundColor = [UIColor purpleColor];
    UIViewController *fourController = [UIViewController new];
    fourController.view.backgroundColor = [UIColor orangeColor];
    [controllers addObject:threeController];
    [controllers addObject:fourController];
    
    NMBottomTabBarController *tabBarController = (NMBottomTabBarController *)self.window.rootViewController;
    tabBarController.controllers = [NSArray arrayWithArray:controllers];
    
    tabBarController.tabBar.separatorImage = [UIImage imageNamed:@"separator.jpg"];

    [tabBarController.tabBar configureTabAtIndex:0 andTitleOrientation :kTitleToRightOfIcon  withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_normal"] selectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_selected"] iconImage:[UIImage imageNamed:@"weather_normal"]  iconSelectedImage: [UIImage imageNamed:@"weather_selected"] andText:@"天气" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor redColor]];
    [tabBarController.tabBar configureTabAtIndex:1 andTitleOrientation : kTitleToRightOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_normal"] selectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_selected"] iconImage:[UIImage imageNamed:@"forecast_normal"]  iconSelectedImage: [UIImage imageNamed:@"forecast_selected"] andText:@"预报" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [tabBarController.tabBar configureTabAtIndex:2 andTitleOrientation : kTitleToRightOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_normal"] selectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_selected"] iconImage:[UIImage imageNamed:@"zhishu_normal"]  iconSelectedImage: [UIImage imageNamed:@"zhishu_selected"] andText:@"指数" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [tabBarController.tabBar configureTabAtIndex:3 andTitleOrientation : kTitleToRightOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_normal"] selectedBackgroundImage:[UIImage imageNamed:@"tabbar_bg_selected"] iconImage:[UIImage imageNamed:@""]  iconSelectedImage: [UIImage imageNamed:@""] andText:@"更多" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    
    [tabBarController selectTabAtIndex:0];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
