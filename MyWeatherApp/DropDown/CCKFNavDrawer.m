//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "CCKFNavDrawer.h"
#import "DropDownView.h"

#define SHAWDOW_ALPHA 0.4
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350

#define SCREEN_WIDTH  self.view.frame.size.width

@interface CCKFNavDrawer ()

@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DropDownView *dropView;

@end

@implementation CCKFNavDrawer

#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setUpDrawer];
    
    // block
    __weak CCKFNavDrawer *wself = self;
    self.dropView.closeNaviBlock = ^(NSString *cityName){
        CCKFNavDrawer *sself = wself;
        [sself closeNavigationDrawer];
        [sself.CCKFNavDrawerDelegate CCKFNavDrawerSelection:cityName];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.panGest setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.panGest setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
    self.dropView = [[[NSBundle mainBundle] loadNibNamed:@"DropDownView" owner:self options:nil] objectAtIndex:0];
    //self.dropView.backgroundColor = [UIColor redColor];
    
    self.meunHeight = (self.view.frame.size.height*3)/4;
    self.menuWidth  = self.view.frame.size.width;//self.dropView.frame.size.width;
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    //self.dropView.frame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    [self.dropView setFrame:self.outFrame];
    [self.view addSubview:self.dropView];
    
//    self.dropView.alpha = 1.f;
//    self.dropView.provinceView.alpha = 1.f;
//    self.dropView.cityView.alpha = 1.f;
    
    // drawer list
    [self.dropView.provinceTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    [self.dropView.cityTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    //self.dropView.provinceTable.dataSource = self;
    //self.dropView.provinceTable.delegate = self;
    
    // gesture on self.view
    self.panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.panGest.maximumNumberOfTouches = 1;
    self.panGest.minimumNumberOfTouches = 1;
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.panGest];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

- (void)drawerToggle
{
    if (!self.isOpen) {
        [self openNavigationDrawer];
    }else{
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer{
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.dropView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.dropView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
}

- (void)closeNavigationDrawer{
//    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.dropView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.dropView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.dropView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.dropView.center = CGPointMake(movingx, self.dropView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"end");
        if (self.dropView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.dropView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"row %li",(long)[indexPath row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
    [self closeNavigationDrawer];
}

@end
