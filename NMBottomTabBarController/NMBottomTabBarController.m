//
//  ViewController.m
//  NMBottomTabBarExample
//
//  Created by Prianka Liz Kariat on 04/12/14.
//  Copyright (c) 2014 Prianka Liz. All rights reserved.
//

#import "NMBottomTabBarController.h"
#import "CoreDataController.h"
#import "ProvinceController.h"
#import "CityController.h"
#import "CountyController.h"
#import "Province.h"
#import "City.h"
#import "County.h"

#import "ForecastViewController.h"

@interface NMBottomTabBarController () <NSXMLParserDelegate>

@property (nonatomic, strong) NSString *proID;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSMutableArray *arrayProvince;
@property (nonatomic, strong) NSMutableArray *arrayCity;
@property (nonatomic, strong) NSMutableArray *arrayCounty;

@end

@implementation NMBottomTabBarController
@synthesize controllers = _controllers;

-(id)init{
    
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)awakeFromNib{

    self.tabBar = [NMBottomTabBar new];
    selectedIndex = -1;
    self.controllers = [NSArray new];
    [self.view addSubview:self.tabBar];
    
    containerView = [UIView new];
    [self.view addSubview:containerView];
    
    [self setUpConstraintsForContainerView];
    [self setUpConstraintsForTabBar];
    
    [self.tabBar setDelegate:self];
  
}

-(void)setControllers:(NSArray *)controllers{
    
    _controllers = controllers;
     [self.tabBar layoutTabWihNumberOfButtons:self.controllers.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayProvince = [[NSMutableArray alloc] init];
    self.arrayCity     = [[NSMutableArray alloc] init];  // 初始化
    self.arrayCounty   = [[NSMutableArray alloc] init];
        
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"CityID" ofType:@"xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:xmlPath];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setUpConstraintsForTabBar{
    
    NMBottomTabBar *tempTabBar = self.tabBar;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tempTabBar(==50)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tempTabBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar)]];
    [tempTabBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setNeedsLayout];
    
}

-(void)setUpConstraintsForContainerView {
    
    NMBottomTabBar *tempTabBar = self.tabBar;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-[tempTabBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containerView)]];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setNeedsLayout];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectTabAtIndex:(NSInteger)index{
   
   [self.tabBar setTabSelectedWithIndex:index];
}

-(void)didSelectTabAtIndex:(NSInteger)index{

     if(selectedIndex == -1){
        
        UIViewController *destinationController = [self.controllers objectAtIndex:index];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        [containerView addSubview:destinationController.view];
        [self setUpContsraintsForDestinationCOntrollerView:destinationController.view];
        selectedIndex = index;
    }
    else if(selectedIndex != index){
        
        UIViewController *sourceController = [self.controllers objectAtIndex:selectedIndex];
        UIViewController *destinationController = [self.controllers objectAtIndex:index];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        
        [self transitionFromViewController:sourceController toViewController:destinationController duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
        } completion:^(BOOL finished) {
            
            [sourceController willMoveToParentViewController:nil];
            [sourceController removeFromParentViewController];
           
            [self setUpContsraintsForDestinationCOntrollerView:destinationController.view];
            selectedIndex = index;
            if([self.delegate respondsToSelector:@selector(didSelectTabAtIndex:)]){
                
                [self.delegate didSelectTabAtIndex:selectedIndex];
            }
            
        }];
    }
}

-(BOOL)shouldSelectTabAtIndex:(NSInteger)index{
    
    if([self.delegate respondsToSelector:@selector(shouldSelectTabAtIndex:)]){
    
        return [self.delegate shouldSelectTabAtIndex:index];
    }
    return YES;
}

-(void)setUpContsraintsForDestinationCOntrollerView : (UIView *)view {
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView setNeedsLayout];

}

static NSString * const kChinaElementName    = @"China";
static NSString * const kProvinceElementName = @"province";
static NSString * const kCityElementName     = @"city";
static NSString * const kCountyElementName   = @"county";

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kChinaElementName]) {
        [[ProvinceController sharedInstance] clearAllProvinces];  // 清空数据库，只执行一次
    }
    else if ([elementName isEqualToString:kProvinceElementName]) {
        self.proID = [attributeDict valueForKey:@"id"];
        [[ProvinceController sharedInstance] insertProvince:[[NSArray alloc] initWithObjects:attributeDict, nil]];
        
    }
    else if ([elementName isEqualToString:kCityElementName]) {
        
        self.cityCode = [attributeDict valueForKey:@"id"];
        [[CityController sharedInstance] insertCity:[[NSArray alloc] initWithObjects:attributeDict, nil] toProvince:[self.proID intValue]];
        
    }
    else if ([elementName isEqualToString:kCountyElementName]) {
        [self.arrayCounty addObject:attributeDict];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:kProvinceElementName]) {
 
    }
    else if ([elementName isEqualToString:kCityElementName]) {
        
        [[CountyController sharedInstance] insertCounty:self.arrayCounty toCity:self.cityCode];
        self.arrayCounty = [[NSMutableArray alloc] init];

    }
    else if ([elementName isEqualToString:kCountyElementName]) {
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSString *parserString = string;
}

@end

