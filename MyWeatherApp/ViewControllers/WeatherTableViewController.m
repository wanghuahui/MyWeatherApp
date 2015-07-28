//
//  NMWeatherTableViewController.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/18/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "WeatherTableViewController.h"
//#import "ForecastViewController.h"
#import "DropDownView.h"
#import "WeatherParse.h"

#import "County.h"
#import "CountyController.h"

@interface WeatherTableViewController () <CCKFNavDrawerDelegate>

@property (strong, nonatomic) CCKFNavDrawer *rootNavi;
@property (strong, nonatomic) WeatherParse *weatherParse;
//@property (strong, nonatomic) ForecastViewController *forecastView;

@end

const static NSString *weatherURL = @"http://wthrcdn.etouch.cn/WeatherApi?citykey=";

@implementation WeatherTableViewController
{
    NSArray *basicDesc;
    NSArray *basicArray;
    NSArray *envirDesc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    basicDesc = @[@"更新时间：", @"温度：", @"风力：", @"湿度：", @"风向：", @"日出时间：", @"日落时间："];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.rootNavi = (CCKFNavDrawer *)self.navigationController;
    [self.rootNavi setCCKFNavDrawerDelegate:self];
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuSelected:)];
    [leftButton setTintColor:[UIColor grayColor]];
    self.navigationItem.leftBarButtonItem = leftButton;
    //self.navigationItem.title = @"天气应用";
    
    //self.dropView = [[DropDownView alloc] init];//[[[NSBundle mainBundle] loadNibNamed:@"DropDownView" owner:self options:nil] objectAtIndex:0];
    //__weak NMWeatherTableViewController *wself = self;
    //[self.dropView setDropDownDelegate:wself];
    //self.dropView.dropDownDelegate = self;
//    __weak NMWeatherTableViewController *wself = self;
//    self.dropView.showCityWeather = ^(NSString *cityName){
//        wself.navigationItem.title = cityName;
//    
//    };
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)leftMenuSelected:(id)sender
{
    NSLog(@"Tap");
    [self.rootNavi drawerToggle];
    //self.navigationItem.title = @"tap";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)CCKFNavDrawerSelection:(NSString *)name {
    self.navigationItem.title = name;
    County *county = [[CountyController sharedInstance] fetchCountyWithName:name];
    if (county) {
        [[NSUserDefaults standardUserDefaults] setObject:county.weatherCode forKey:@"WeatherCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //NSString *weatherCode = county.weatherCode;
    NSString *url = [NSString stringWithFormat:@"%@%@", weatherURL, county.weatherCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //self.weatherParse = [[WeatherParse alloc] initWithURLPath:url];
        [[WeatherParse sharedInstance] parseWeatherURL:url];
        
        basicArray = [[WeatherParse sharedInstance] basicArray];
        if (basicArray.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *s1 = [NSString stringWithFormat:@"pm2.5：%@", [[WeatherParse sharedInstance] envirArray][1]];
                NSString *s2 = [NSString stringWithFormat:@"空气质量：%@", [[WeatherParse sharedInstance] envirArray][3]];
                NSString *s3 = [NSString stringWithFormat:@"建议：%@", [[WeatherParse sharedInstance] envirArray][2]];
                envirDesc = [[NSArray alloc] initWithObjects:s1, s2, s3, nil];
                
                [self.tableView reloadData];
            });
        }
    });
    
    //[[WeatherParse alloc] initWithURLPath:url];
    //[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        
        return basicArray.count;
    }
    else {
        return [envirDesc count];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat width = self.tableView.frame.size.width;
//    CGSize contextSize = CGSizeMake(width, 1000);
//    
//    // 计算时设置的字体大小，和显示文本的label字体大小一致
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
//    NSString *content;
//    if (indexPath.section == 0) {
//        content = [self.weatherParse.basicArray objectAtIndex:indexPath.row];
//    }
//    else {
//        content = [envirDesc objectAtIndex:indexPath.row];
//    }
//    
//    // 计算显示内容所需最小尺寸
//    CGRect rect = [content boundingRectWithSize:contextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//    //CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
//    return rect.size.height + 24;
//}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.estimatedRowHeight = 44.0;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *weatherCell = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weatherCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:weatherCell];
    }
    
    // Configure the cell...
    NSString *desc;
    //NSUInteger count = self.weatherParse.basicArray.count;
    if (indexPath.section == 0) {
        desc = [NSString stringWithFormat:@"%@%@", basicDesc[indexPath.row], basicArray[indexPath.row]];
    }
    else if (indexPath.section == 1) {
        desc = (NSString *)envirDesc[indexPath.row];
    }
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = desc;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"天气";
    }
    else {
        return @"环境";
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
