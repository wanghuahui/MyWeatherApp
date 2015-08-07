//
//  ForecastViewController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/26/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "ForecastViewController.h"
#import "ForecastDetailViewController.h"
#import "WeatherParse.h"

@interface ForecastViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *forecastArray;

@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSArray *array = [[WeatherParse sharedInstance] forecastArray];
    if (array.count > 0) {
        NSUInteger count = array.count / 10;
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
        for (int i=0; i<count; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%@", array[i*10+2]];  // 提取温度
            NSScanner *scanner = [NSScanner scannerWithString:wendu];
            NSString *s1, *s2;
            if ([scanner scanString:@"高温 " intoString:NULL]) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet illegalCharacterSet] intoString:&s1];
            }
            wendu = [NSString stringWithFormat:@"%@", array[i*10+3]];  // 提取温度
            scanner = [NSScanner scannerWithString:wendu];
            if ([scanner scanString:@"低温 " intoString:NULL]) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet illegalCharacterSet] intoString:&s2];
            }
            
            NSString *date = [NSString stringWithFormat:@"%@%@  %@/%@  %@", array[i*10], array[i*10+1], s1, s2, array[i*10+4]];
            [mutableArray addObject:date];

        }
        self.forecastArray = [NSArray arrayWithArray:mutableArray];
        mutableArray = nil;
    }
    
    [self.tableView reloadData];
}


#pragma mark - Tableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forecastArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *forecastCell = @"ForecastCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forecastCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:forecastCell];
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [self.forecastArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    ForecastDetailViewController *detailView = (ForecastDetailViewController *)segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //detailView.detailArray = [[NSArray alloc] initWithArray:self.forecastArray];
    detailView.detailString = self.forecastArray[indexPath.row];
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
