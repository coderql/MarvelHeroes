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
#import "MSHHeroDetailPresenter.h"
#import "MSHEntity.h"

static NSString *const kInfoCellIdentifier = @"infoCell";
static NSString *const kEntityComic = @"comic";
static NSString *const kEntityEvent = @"event";
static NSString *const kEntityStory = @"story";
static NSString *const kEntitySeries = @"series";

@interface MSHDetailController () <UITableViewDelegate, UITableViewDataSource, MSHHeroDetailProtocol>
{
//    CGFloat headerViewHeight;
    NSArray *entities;
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) MSHDetailHeaderView *headerView;
@property (nonatomic, strong) MSHHeroDetailPresenter *presenter;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
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
    _presenter = [[MSHHeroDetailPresenter alloc] initWithView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showProgress];
    dispatch_group_t group = dispatch_group_create();
    NSArray *selStrArray = @[@"getComicsWithHeroId:", @"getEventsWithHeroId:", @"getStoriesWithHeroId:", @"getSeriesWithHeroId:"];
    for (NSInteger index = 0; index < selStrArray.count; index++) {
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            [self.presenter performSelector:NSSelectorFromString(selStrArray[index]) withObject:@(self.selectedHero.heroId)];
        });
    }
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        [self hideProgress];
        [self.infoTableView reloadData];
    });
}

- (void)setupNavigationBar {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    backImageView.frame = CGRectMake(0, 0, kDefaultHeight, kDefaultHeight);
    backImageView.contentMode = UIViewContentModeLeft;
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
    }
    return _headerView;
}

- (NSMutableDictionary *)infoDict {
    if (_infoDict == nil) {
        _infoDict = [[NSMutableDictionary alloc] initWithCapacity:entities.count];
        for (NSInteger index = 0; index < entities.count; index++) {
            [_infoDict setObject:[NSMutableArray new] forKey:entities[index]];
        }
    }
    return _infoDict;
}

#pragma mark - methods
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MSHHeroDetailProtocol
- (void)getComicsSuccess:(NSArray *)comics {
    [[self.infoDict objectForKey:entities[0]] addObjectsFromArray:comics];
    [self.infoTableView reloadData];
}

- (void)getComicsFailure:(NSError *)error {
    MSHLog(@"%@: %@", NSStringFromSelector(_cmd), error);
}

- (void)getEventsSuccess:(NSArray *)events {
    [[self.infoDict objectForKey:entities[1]] addObjectsFromArray:events];
    [self.infoTableView reloadData];
}

- (void)getEventsFailure:(NSError *)error {
    MSHLog(@"%@: %@", NSStringFromSelector(_cmd), error);
}

- (void)getStoriesSuccess:(NSArray *)stories {
    [[self.infoDict objectForKey:entities[2]] addObjectsFromArray:stories];
    [self.infoTableView reloadData];
}

- (void)getStoriesFailure:(NSError *)error {
    MSHLog(@"%@: %@", NSStringFromSelector(_cmd), error);
}

- (void)getSeriesSuccess:(NSArray *)series {
    [[self.infoDict objectForKey:entities[3]] addObjectsFromArray:series];
    [self.infoTableView reloadData];
}

- (void)getSeriesFailure:(NSError *)error {
    MSHLog(@"%@: %@", NSStringFromSelector(_cmd), error);
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
    return ((NSMutableArray *)[self.infoDict objectForKey:entities[section]]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kInfoCellIdentifier];
    }
    // Configure the cell...
    NSMutableArray *subArray = [self.infoDict objectForKey:entities[indexPath.section]];
    MSHEntity *entity = subArray[indexPath.row];
    cell.textLabel.text = entity.title;
    cell.detailTextLabel.text = entity.desc;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return entities[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return CGRectGetHeight(cell.textLabel.frame) + CGRectGetHeight(cell.detailTextLabel.frame);
    NSMutableArray *subArray = [self.infoDict objectForKey:entities[indexPath.section]];
    MSHEntity *entity = subArray[indexPath.row];
    return [MSHUtils heightOfText:entity.title containderWidth:SCREEN_WIDTH - 2 * 16 fontSize:16.f] + [MSHUtils heightOfText:entity.desc containderWidth:SCREEN_WIDTH - 2 * 16 fontSize:13.0f] + 16;
}

- (void)dealloc {
    MSHLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
