//
//  ZHChildTableViewController.m
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "ZHChildTableViewController.h"

@interface ZHChildTableViewController ()<UIScrollViewDelegate>

@end

@implementation ZHChildTableViewController {
    
    BOOL _canScroll;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    // 上拉加载控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAccessRoofNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAwayRoofNotification object:nil];
}

- (void)loadMoreData {
    
    if ([[self extensionDelegate] respondsToSelector:@selector(loadMoreData)]) {
        [[self extensionDelegate] loadMoreData];
    }
}

- (void)refreshWithData:(NSArray *)data {
    
    self.dataSource = [NSMutableArray array];
    for (NSString *text in data) {
        [[self dataSource] addObject:text];
    }    
    [[self tableView] reloadData];
}

#pragma mark - notification

-(void)notification:(NSNotification *)notification {
    
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kAccessRoofNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kAwayRoofNotification]){
        self.tableView.contentOffset = CGPointZero;
        _canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAwayRoofNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.dataSource[[indexPath row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
