//
//  NMWeatherTableViewController.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/18/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@protocol WeatherViewDelegate <NSObject>

@optional

- (void)selectedArray:(NSArray *)array;

@end

@interface WeatherTableViewController : UITableViewController

//- (void)setNaviName:(NSString *)name;
@property (assign, nonatomic) id <WeatherViewDelegate> delegate;


@end
