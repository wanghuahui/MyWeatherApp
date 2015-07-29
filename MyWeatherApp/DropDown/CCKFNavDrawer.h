//
//  CCKFNavDrawer.h
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCKFNavDrawerDelegate <NSObject>

@optional

- (void)CCKFNavDrawerSelection:(NSString *)name;

@end

@interface CCKFNavDrawer : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGest;
@property (weak, nonatomic) id<CCKFNavDrawerDelegate> CCKFNavDrawerDelegate;

- (void)drawerToggle;

@end
