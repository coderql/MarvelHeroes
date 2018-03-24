//
//  ViewController.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "MSHMarvelHeroService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MSHMarvelHeroService *service = [[MSHMarvelHeroService alloc] init];
    [service getHeroesOffset:0
                       limit:20
              nameStartsWith:nil
               resultHandler:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
