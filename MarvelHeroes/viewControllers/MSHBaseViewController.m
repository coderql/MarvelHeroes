//
//  MSHBaseViewController.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHBaseViewController.h"
#import "MSHLoadingView.h"

@interface MSHBaseViewController ()
@property (nonatomic, strong) MSHLoadingView *loadingView;
@end

@implementation MSHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (MSHLoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[MSHLoadingView alloc] init];
        _loadingView.center = self.view.center;
    }
    return _loadingView;
}

- (void)showProgress {
    self.view.userInteractionEnabled = NO;
    if (_loadingView == nil) {
        [self.view addSubview:self.loadingView];
        [self.loadingView startLoading];
    } else {
        if (self.loadingView.isHidden) {
            [self.loadingView startLoading];
            [self.loadingView setHidden:NO];
        }
    }
}

- (void)hideProgress {
    self.view.userInteractionEnabled = YES;
    if (_loadingView == nil) {
        return;
    }
    if (!self.loadingView.isHidden) {
        [self.loadingView stopLoading];
        [self.loadingView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
