//
//  ZHMainTabPagerControllerViewController.m
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "ZHMainTabPagerControllerViewController.h"
#import "ZHChildTableViewController.h"

@interface ZHMainTabPagerControllerViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation ZHMainTabPagerControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = kScreenWidth / 3 - 10;
    
    self.dataSource = self;
    self.delegate = self;
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; ++i) {
        [datas addObject:[NSString stringWithFormat:@"控制器 %ld", i+1]];
    }
    _datas = [datas copy];
    
    [self reloadData];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        ZHChildTableViewController *firstViewController = [[ZHChildTableViewController alloc]init];
        firstViewController.view.backgroundColor = [UIColor redColor];
        return firstViewController;
    }else if (index == 1) {
        ZHChildTableViewController *secondViewController = [[ZHChildTableViewController alloc]init];
        secondViewController.view.backgroundColor = [UIColor yellowColor];
        return secondViewController;
    }else {
        ZHChildTableViewController *thirdViewController = [[ZHChildTableViewController alloc]init];
        thirdViewController.view.backgroundColor = [UIColor greenColor];
        return thirdViewController;
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
