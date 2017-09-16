//
//  ZHMainTabPagerControllerViewController.m
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "ZHMainTabPagerControllerViewController.h"

@interface ZHMainTabPagerControllerViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate, ZHChildTableViewControllerDelegate>

@property (nonatomic, strong) ZHChildTableViewController *firstChildTableViewController;
@property (nonatomic, strong) ZHChildTableViewController *secondChildTableViewController;

@property (nonatomic, strong) NSArray *tabDataSource;

@end

@implementation ZHMainTabPagerControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = kScreenWidth / 2.1f;
    
    self.dataSource = self;
    self.delegate = self;
    
    [self _handleTabPagerBarData];
}

- (void)_handleTabPagerBarData {
    
    NSMutableArray *tabDataSource = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; ++i) {
        [tabDataSource addObject:[NSString stringWithFormat:@"控制器 %ld", i+1]];
    }
    
    self.tabDataSource = [tabDataSource copy];

    [self reloadData];
}

#pragma mark - accessor
- (void)setDataSourceDictionary:(NSMutableDictionary *)dataSourceDictionary {
    if (_dataSourceDictionary != dataSourceDictionary) {
        _dataSourceDictionary = dataSourceDictionary;
    }
    self.firstChildTableViewController.dataSource = dataSourceDictionary[@(0)];
    self.secondChildTableViewController.dataSource = dataSourceDictionary[@(1)];
    [[[self firstChildTableViewController] tableView] reloadData];
    [[[self secondChildTableViewController] tableView] reloadData];
}

- (ZHChildTableViewController *)firstChildTableViewController {
    if (nil == _firstChildTableViewController) {
        _firstChildTableViewController = [[ZHChildTableViewController alloc] init];
    }
    return _firstChildTableViewController;
}

- (ZHChildTableViewController *)secondChildTableViewController {
    if (nil == _secondChildTableViewController) {
        _secondChildTableViewController = [[ZHChildTableViewController alloc] init];
    }
    return _secondChildTableViewController;
}

#pragma mark - ZHChildTableViewControllerDelegate
- (void)loadMoreData {
    
    self.loadMoreDataHandler(self.tabBar.curIndex);
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [[self tabDataSource] count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        ZHChildTableViewController *firstViewController = self.firstChildTableViewController;
        firstViewController.extensionDelegate = self;
        return firstViewController;
    }else {
        ZHChildTableViewController *secondViewController = self.secondChildTableViewController;
        secondViewController.extensionDelegate = self;
        return secondViewController;
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = self.tabDataSource[index];
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
