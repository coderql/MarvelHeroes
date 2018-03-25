//
//  MSHDetailController.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHDetailController.h"
#import "MSHHero.h"
#import "MSHDetailHeaderView.h"

static NSString *const kInfoCellIdentifier = @"infoCell";

@interface MSHDetailController () <UITableViewDelegate, UITableViewDataSource>
{
//    CGFloat headerViewHeight;
    NSArray *entities;
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) MSHDetailHeaderView *headerView;
@end

@implementation MSHDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = self.selectedHero.name;
    [self setupNavigationBar];
//    headerViewHeight = SCREEN_WIDTH / kHeroImageRatio + 53.f + 60.f;
    entities = @[@"comics", @"events", @"stories", @"series"];
    [self setupTableView];
}

- (void)setupNavigationBar {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backImageView];
}

- (void)setupTableView {
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MSH_StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MSH_StatusBarAndNavigationBarHeight - MSH_TabbarSafeBottomMargin) style:UITableViewStylePlain];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
    self.infoTableView.tableHeaderView = self.headerView;
}

- (MSHDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[MSHDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.infoTableView.frame), 0)];
        _headerView.hero = self.selectedHero;
//        _headerView.nameLabel.text = self.selectedHero.name;
//        _headerView.descLabel.text = self.selectedHero.desc;
    }
    return _headerView;
}

#pragma mark - methods
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return entities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInfoCellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = @"test";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return entities[section];
}

@end
