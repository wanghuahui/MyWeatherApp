//
//  DropDownView.h
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/19/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CloseNaviBlock)(NSString *cityName);
//typedef void (^ShowCityWeather)(NSString *cityName);

@interface DropDownView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *provinceView;
@property (strong, nonatomic) UITableView *provinceTableView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property (strong, nonatomic) CloseNaviBlock closeNaviBlock;
//@property (strong, nonatomic) ShowCityWeather showCityWeather;

//@property (weak, nonatomic) id<DropDownDelegate> dropDownDelegate;

@end
