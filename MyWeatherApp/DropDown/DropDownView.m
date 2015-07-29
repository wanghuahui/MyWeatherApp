//
//  DropDownView.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 6/19/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "DropDownView.h"
#import "DropDownViewCell.h"
//#import "WeatherTableViewController.h"

#import "ProvinceController.h"
#import "Province.h"
#import "CityController.h"
#import "City.h"
#import "CountyController.h"
#import "County.h"

@implementation DropDownView {
    
    NSArray *arrayProvinces;
    NSArray *arrayCitys;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    //[self.provinceTable registerNib:[UINib nibWithNibName:@"DropDownViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DropDownViewCell class])];
    self.provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height) style:UITableViewStylePlain];
    self.provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.provinceTableView.rowHeight = 40;
    [self.provinceView addSubview:self.provinceTableView];
    
    [self.provinceTableView registerNib:[UINib nibWithNibName:@"DropDownViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DropDownViewCell class])];
    [self.cityTableView registerNib:[UINib nibWithNibName:@"DropDownViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DropDownViewCell class])];
    
    self.provinceTableView.dataSource = self;
    self.provinceTableView.delegate   = self;
    
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    
    [self setDataSource];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.provinceView.frame = CGRectMake(0, 0, rect.size.width/2, rect.size.height+50);
    self.provinceTableView.frame = CGRectMake(0, 0, rect.size.width/2, rect.size.height+50);
    self.cityView.frame = CGRectMake(rect.size.width/2, 0, rect.size.width/2, rect.size.height+50);
    self.cityTableView.frame = CGRectMake(0, 0, rect.size.width/2, rect.size.height+50);

}


#pragma mark - UITableViewDataSource

- (void)setDataSource
{
    arrayProvinces = [[ProvinceController sharedInstance] fetchProvinces];
    arrayCitys = [[CityController sharedInstance] fetchCityFromProvince:[arrayProvinces objectAtIndex:0]];
    [_cityTableView reloadData];
    [_provinceTableView reloadData];
    
}

#pragma mark - UIcolor


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTableView)
        return arrayProvinces.count;
    else if (tableView == self.cityTableView)
        return arrayCitys.count;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DropDownViewCell" owner:self options:nil] objectAtIndex:0];
    
    if (tableView == _provinceTableView) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        NSArray *selectRows = [tableView indexPathsForSelectedRows];
        if (selectRows.count == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_provinceTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            selectRows = [tableView indexPathsForSelectedRows];
        }
        for (NSIndexPath *i in selectRows) {
            if (![i isEqual:indexPath])
            {
                cell.titleLabel.textColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.titleLabel.textColor = [UIColor grayColor];
                //cell.contentView.backgroundColor = [UIColor lightGrayColor];
            }
        }
        
    }
    else if (tableView == _cityTableView) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        NSArray *selectRows = [tableView indexPathsForSelectedRows];
        if (selectRows.count == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_cityTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            selectRows = [tableView indexPathsForSelectedRows];
        }
        
        for (NSIndexPath *i in selectRows) {
            if (![i isEqual:indexPath]) {
                cell.titleLabel.textColor = [UIColor lightGrayColor];
            }
            else {
                cell.titleLabel.textColor = [UIColor grayColor];
                //cell.contentView.backgroundColor = [UIColor lightGrayColor];
            }
        }
        
    }
    
//    // Configure the cell...
    if (tableView == _provinceTableView) {
        Province *province = [arrayProvinces objectAtIndex:[indexPath row]];
        cell.titleLabel.text = province.provinceName;
    }
    else if (tableView == _cityTableView) {
        City *city = [arrayCitys objectAtIndex:[indexPath row]];
        cell.titleLabel.text = city.cityName;
    }
    
    return cell;

}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _provinceTableView) {
        if (indexPath.row != 0) {
            DropDownViewCell *selectCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            selectCell.titleLabel.textColor = [UIColor grayColor];
            //selectCell.contentView.backgroundColor = [UIColor lightGrayColor];
            
            NSIndexPath *defaultPath = [NSIndexPath indexPathForRow:0 inSection:0];
            DropDownViewCell *defaultCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:defaultPath];
            defaultCell.titleLabel.textColor = [UIColor lightGrayColor];
            defaultCell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            DropDownViewCell *selectedCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            selectedCell.titleLabel.textColor = [UIColor grayColor];
            //selectedCell.contentView.backgroundColor = [UIColor lightGrayColor];
        }
        Province *province = [[ProvinceController sharedInstance] fetchProvinceWithCode:indexPath.row+1];
        arrayCitys = [[CityController sharedInstance] fetchCityFromProvince:province];
        
        [_cityTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_cityTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    else if (tableView == _cityTableView) {
        DropDownViewCell *selectCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        selectCell.titleLabel.textColor = [UIColor grayColor];
        
        NSString *cityName = selectCell.titleLabel.text;
        if (self.closeNaviBlock) {
            self.closeNaviBlock(cityName);
        }

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _provinceTableView) {
        DropDownViewCell *deselectedCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        deselectedCell.titleLabel.textColor = [UIColor lightGrayColor];
        deselectedCell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else if (tableView == _cityTableView) {
        DropDownViewCell *deselectedCell = (DropDownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        deselectedCell.titleLabel.textColor = [UIColor lightGrayColor];
        deselectedCell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
