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
#import "MSHNavigationBar.h"

static NSString *const kInfoCellIdentifier = @"infoCell";
static NSString *const kEntityComic = @"comic";
static NSString *const kEntityEvent = @"event";
static NSString *const kEntityStory = @"story";
static NSString *const kEntitySeries = @"series";

@interface MSHDetailController () <UITableViewDelegate, UITableViewDataSource, MSHHeroDetailProtocol, UIViewControllerTransitioningDelegate>
{
    NSArray *entities;
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) MSHDetailHeaderView *headerView;
@property (nonatomic, strong) MSHHeroDetailPresenter *presenter;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic, strong) MSHNavigationBar *navigationBar;
@end

@implementation MSHDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self setupNavigationBar];
    entities = @[@"comics", @"events", @"stories", @"series"];
    [self setupTableView];
    _presenter = [[MSHHeroDetailPresenter alloc] initWithView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    _navigationBar = [[MSHNavigationBar alloc] initWithFrame:CGRectMake(0, MSH_StatusBarHeight, SCREEN_WIDTH, kDefaultHeight)];
    _navigationBar.titleLabel.text = self.selectedHero.name;
    __weak __typeof(self) weakSelf = self;
    _navigationBar.backHandler = ^{
        weakSelf.navigationBar.hidden = YES;
        CGRect finalFrame = weakSelf.infoTableView.frame;
        finalFrame.origin.y -= MSH_StatusBarAndNavigationBarHeight;
        finalFrame.size.height += MSH_StatusBarAndNavigationBarHeight;
        weakSelf.infoTableView.frame = finalFrame;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:self.navigationBar];
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
        _headerView.heroImageView.image = self.heroImage;
        __weak __typeof(self) weakSelf = self;
        _headerView.favorHandler = ^(int heroId, BOOL isFavor) {
            [weakSelf.presenter favorHero:isFavor heroId:heroId];
        };
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

- (void)favorCompleted:(NSError *)error {
    if (error == nil) {
        self.selectedHero.isFavorite = !self.selectedHero.isFavorite;
        [self.headerView updateFavorImageView];
        if (self.detailVCDelegate && [self.detailVCDelegate respondsToSelector:@selector(heroChanged:)]) {
            [self.detailVCDelegate heroChanged:self.selectedHero];
        }
    } else {
        NSLog(@"favor error = %@", error);
    }
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
    return [MSHUtils heightOfText:entity.title containerWidth:SCREEN_WIDTH - 2 * 16 fontSize:16.f] + [MSHUtils heightOfText:entity.desc containerWidth:SCREEN_WIDTH - 2 * 16 fontSize:13.0f] + 16;
}

- (void)dealloc {
    MSHLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
