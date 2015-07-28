//
//  ForecastDetailViewController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/28/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "ForecastDetailViewController.h"

@interface ForecastDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end

@implementation ForecastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.detailString.length > 0) {
        NSArray *arr = [self.detailString componentsSeparatedByString:@"  "];
        NSString *s = arr[0];
        self.dateLabel.text = [s substringWithRange:NSMakeRange(s.length-3, 3)];
        self.tempLabel.text = arr[1];
        self.weatherLabel.text = arr[2];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
