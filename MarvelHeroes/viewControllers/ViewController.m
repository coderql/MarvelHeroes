//
//  ViewController.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "MSHCollectionViewCell.h"
#import "MSHHero.h"
#import "MSHPageInfo.h"
#import "MSHDetailController.h"
#import "MSHHomepagePresenter.h"
#import "MSHSearchView.h"
#import "MSHTransition.h"

static NSString *const kCellIdentifier = @"mainCell";
static CGFloat const kCellSpace = 10.f;
static CGFloat const kCellBottomAreaHeight = 53.f;

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, MSHHomepageProtocol, MSHSearchViewDelegate, UIViewControllerTransitioningDelegate, MSHDetailControllerDelegate>
{
    CGFloat cellWidth;
}
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray <MSHHero *> *heroArray;
@property (nonatomic, strong) NSMutableArray <MSHHero *> *searchResultArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MSHHomepagePresenter *presenter;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) BOOL noMoreSearchData;
@property (nonatomic, strong) MSHSearchView *searchView;
@property (nonatomic, strong) MSHTransition *transition;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _presenter = [[MSHHomepagePresenter alloc] initWithView:self];
    [self setupCollectionView];
//    [self loadHeroList];
    [self setupRefresh];
    [self setupTransition];
}

- (NSMutableArray<MSHHero *> *)heroArray {
    if (_heroArray == nil) {
        _heroArray = [NSMutableArray new];
    }
    return _heroArray;
}

- (NSMutableArray<MSHHero *> *)searchResultArray {
    if (_searchResultArray == nil) {
        _searchResultArray = [NSMutableArray new];
    }
    return _searchResultArray;
}

- (void)setupCollectionView {
    
    cellWidth = (SCREEN_WIDTH - 3 * kCellSpace) / 2;
//    _mainCollectionView =
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumLineSpacing:kCellSpace];
    [layout setMinimumInteritemSpacing:kCellSpace];
    [layout setSectionInset:UIEdgeInsetsMake(kCellSpace, kCellSpace, kCellSpace, kCellSpace)];
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MSH_StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - MSH_StatusBarAndNavigationBarHeight - MSH_TabbarSafeBottomMargin) collectionViewLayout:layout];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"MSHCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    _mainCollectionView.backgroundColor = kBackgroundColor;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.bounces = YES;
    [self.view addSubview:self.mainCollectionView];
    
    _searchView = [[MSHSearchView alloc] initWithFrame:CGRectMake(0, MSH_StatusBarHeight, SCREEN_WIDTH, kDefaultHeight)];
    _searchView.searchDelegate = self;
    [self.view addSubview:self.searchView];
}

- (void)setupRefresh {
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.mainCollectionView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
    [self refreshStateChange:self.refreshControl];
}

- (void)setupTransition {
    _transition = [[MSHTransition alloc] init];
    __weak __typeof(self) weakSelf = self;
    _transition.dismissCompletion = ^{
        weakSelf.selectedImageView.hidden = NO;
    };
}

- (void)refreshStateChange:(UIRefreshControl *)control {
    self.noMoreData = NO;
    self.noMoreSearchData = NO;
    if (self.searchView.searchActive) {
        [self beginSearchText:self.searchView.searchTextField.text];
    } else {
        [self.presenter loadFirstPage];
    }
}

- (void)loadMoreData {
    [self showProgress];
    if (self.searchView.searchActive) {
        [self.presenter searchMoreWithText:self.searchView.searchTextField.text offset:(int)self.searchResultArray.count];
    } else {
        [self.presenter loadNextPageWithOffset:(int)self.heroArray.count];
    }
}

- (void)beginSearchText:(NSString *)text {
    NSString *destText = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([MSHUtils isEmptyString:destText]) {
        [self hideProgress];
        return;
    }
    [self.presenter searchWithText:text];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchView.searchTextField.isEditing) {
        [self.searchView endSearching];
    }
//    MSHLog(@"scrollViewWillBeginDragging");
    if (scrollView.contentOffset.y + scrollView.frame.size.height + ((MSH_iPhoneX)? 0.5f: 0) >= scrollView.contentSize.height) {
        if (self.searchView.searchActive) {
            if (!self.noMoreSearchData) {
                [self loadMoreData];
            }
        } else {
            if (!self.noMoreData) {
                [self loadMoreData];
            }
        }
    }
}

#pragma mark - MSHDetailControllerDelegate
- (void)heroChanged:(MSHHero *)hero {
    NSInteger index = self.searchView.searchActive? [self.searchResultArray indexOfObject:hero]: [self.heroArray indexOfObject:hero];
    [self.mainCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

#pragma mark - MSHSearchViewDelegate
- (void)searchView:(UIView *)searchView didEndEditing:(NSString *)text {
    [self showProgress];
    self.noMoreSearchData = NO;
    [self beginSearchText:text];
}

- (void)searchView:(UIView *)searchView cancelButtonClicked:(UIButton *)button {
    self.noMoreSearchData = NO;
    [self.refreshControl beginRefreshing];
    [self refreshStateChange:self.refreshControl];
//    [self.mainCollectionView reloadData];
}

#pragma mark - MSHHomepageProtocol
- (void)loadSuccess:(MSHPageInfo *)pageInfo
        isFirstPage:(BOOL)isFirstPage
         noMoreData:(BOOL)isNoMoreData {
    if (isFirstPage) {
        [self.heroArray removeAllObjects];
        [self.refreshControl endRefreshing];
    } else {
        [self hideProgress];
    }
    [self.heroArray addObjectsFromArray:pageInfo.data];
    if (isNoMoreData) {
        self.noMoreData = YES;
    }
    [self.mainCollectionView reloadData];
}

- (void)loadFailure:(NSError *)error
        isFirstPage:(BOOL)isFirstPage {
    if (isFirstPage) {
        [self.refreshControl endRefreshing];
    }
    [self hideProgress];
}

- (void)searchSuccess:(MSHPageInfo *)pageInfo
          isFirstPage:(BOOL)isFirstPage
           noMoreData:(BOOL)isNoMoreData {
//    [self loadSuccess:pageInfo isFirstPage:isFirstPage noMoreData:isNoMoreData];
    [self hideProgress];
    if (isFirstPage) {
        [self.searchResultArray removeAllObjects];
        [self.refreshControl endRefreshing];
        [self.mainCollectionView setContentOffset:CGPointZero animated:YES];
    }
    [self.searchResultArray addObjectsFromArray:pageInfo.data];
    if (isNoMoreData) {
        self.noMoreSearchData = YES;
    }
    [self.mainCollectionView reloadData];
}

- (void)searchFailure:(NSError *)error
          isFirstPage:(BOOL)isFirstPage {
    [self loadFailure:error isFirstPage:isFirstPage];
    if (isFirstPage) {
        [self.searchResultArray removeAllObjects];
        [self.mainCollectionView reloadData];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchView.searchActive? self.searchResultArray.count: self.heroArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    MSHHero *hero = (self.searchView.searchActive)? self.searchResultArray[indexPath.item]: self.heroArray[indexPath.item];
    cell.hero = hero;
    [cell.mainImageView setImageUrl:[NSURL URLWithString:[self.presenter getImageUrlWithThumbnail:hero.thumbnail]] placeholder:nil];
//    cell.nameLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.item + 1];
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth,  cellWidth / kHeroImageRatio + kCellBottomAreaHeight);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSHCollectionViewCell *cell = (MSHCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    self.selectedImageView = cell.mainImageView;
    MSHDetailController *detailController = [MSHDetailController new];
    detailController.selectedHero = (self.searchView.searchActive)? self.searchResultArray[indexPath.item]: self.heroArray[indexPath.item];
    detailController.heroImage = cell.mainImageView.image;
    detailController.detailVCDelegate = self;
    detailController.transitioningDelegate = self;
    [self presentViewController:detailController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transition.originFrame = [self.selectedImageView.superview convertRect:self.selectedImageView.frame toView:nil];
    self.transition.presenting = YES;
    self.selectedImageView.hidden = YES;
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.presenting = NO;
    return self.transition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
