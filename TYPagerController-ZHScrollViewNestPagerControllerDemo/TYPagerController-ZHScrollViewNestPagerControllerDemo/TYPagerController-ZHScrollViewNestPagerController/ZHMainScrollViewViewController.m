//
//  ZHMainScrollViewViewController.m
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "ZHMainScrollViewViewController.h"

@interface ZHMainScrollViewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) ZHMainTabPagerControllerViewController *pageController;
@property (nonatomic, strong) ZHMainScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableDictionary *dataSourceDictionary;

@end

@implementation ZHMainScrollViewViewController {
    
    BOOL _canScroll;
}

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"怎么形容这个效果";
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAwayRoofNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认可滚动
    _canScroll = YES;
    
    [self _createSubviews];
    
    // 下拉刷新控件
    self.containerScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _fetchAllRemoteData:NO needRequest:YES];
    }];
    [[[self containerScrollView] mj_header] beginRefreshing];
    
    self.dataSourceDictionary = [@{} mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAwayRoofNotification object:nil];
}

#pragma mark - private


- (void)_createSubviews {
    
    [[self view] addSubview:[self containerScrollView]];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self.view).offset(0);
    }];
    
    
    [[self containerScrollView] addSubview:[self headerView]];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        make.height.mas_equalTo(200);
    }];
    
    
    [[self containerScrollView] addSubview:[self contentView]];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        make.height.mas_equalTo(kScreenHeight-64);
    }];
    
    
    [[self contentView] addSubview:[[self pageController] view]];
    self.pageController.pagerController.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight, kScreenWidth);
    __weak __typeof(self) weakSelf = self;
    self.pageController.loadMoreDataHandler = ^(NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf _fetchFirstViewControllerData:YES needRequest:YES];
                break;
            case 1:
                [weakSelf _fetchSecondViewControllerData:YES needRequest:YES];
                break;
            default:
                break;
        }
    };
}

// 请求数据
- (void)_fetchAllRemoteData:(BOOL)append needRequest:(BOOL)needRequest {
    
    [self _fetchFirstViewControllerData:append needRequest:needRequest];
    [self _fetchSecondViewControllerData:append needRequest:needRequest];
}

- (void)_fetchFirstViewControllerData:(BOOL)append needRequest:(BOOL)needRequest {
    if (!needRequest) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [dataArray addObject:[NSString stringWithFormat:@"第一视图控制器的报数:%ld", i]];
    }
    [self _handleFirstViewControllerData:dataArray append:append hasMore:YES];
    
    [self _finishReloadData];
}

- (void)_fetchSecondViewControllerData:(BOOL)append needRequest:(BOOL)needRequest {
    if (!needRequest) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        [dataArray addObject:[NSString stringWithFormat:@"第二视图控制器的报数:%ld", i]];
    }
    [self _handleSecondViewControllerData:dataArray append:append hasMore:YES];
    
    [self _finishReloadData];
}

// 处理数据
- (void)_handleFirstViewControllerData:(NSArray *)data append:(BOOL)append hasMore:(BOOL)hasMore {
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    if (append) {
        dataSourceArray = [NSMutableArray arrayWithArray:self.dataSourceDictionary[@(0)]];
        for (NSString *text in data) {
            [dataSourceArray addObject:text];
        }
    } else {
        for (NSString *text in data) {
            [dataSourceArray addObject:text];
        }
    }
    
    if (hasMore) {
        self.pageController.firstChildTableViewController.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:[[self pageController] firstChildTableViewController] refreshingAction:@selector(loadMoreData)];
    } else {
        [[[[[self pageController] firstChildTableViewController] tableView] mj_footer] endRefreshingWithNoMoreData];
    }
    
    [[self dataSourceDictionary] setObject:dataSourceArray forKey:@(0)];
    
    if (append) {
        ((void (*)(void *, SEL, NSArray *))objc_msgSend)((__bridge void *)(self.pageController.firstChildTableViewController),@selector(refreshWithData:), self.dataSourceDictionary[@(0)]);
    } else {
        self.pageController.dataSourceDictionary = self.dataSourceDictionary;
    }
}

- (void)_handleSecondViewControllerData:(NSArray *)data append:(BOOL)append hasMore:(BOOL)hasMore {
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    if (append) {
        dataSourceArray = [NSMutableArray arrayWithArray:self.dataSourceDictionary[@(1)]];
        for (NSString *text in data) {
            [dataSourceArray addObject:text];
        }
    } else {
        for (NSString *text in data) {
            [dataSourceArray addObject:text];
        }
    }
    
    if (hasMore) {
        self.pageController.secondChildTableViewController.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:[[self pageController] firstChildTableViewController] refreshingAction:@selector(loadMoreData)];
    } else {
        [[[[[self pageController] secondChildTableViewController] tableView] mj_footer] endRefreshingWithNoMoreData];
    }
    
    [[self dataSourceDictionary] setObject:dataSourceArray forKey:@(1)];
    
    if (append) {
        ((void (*)(void *, SEL, NSArray *))objc_msgSend)((__bridge void *)(self.pageController.secondChildTableViewController),@selector(refreshWithData:), self.dataSourceDictionary[@(1)]);
    } else {
        self.pageController.dataSourceDictionary = self.dataSourceDictionary;
    }
}

- (void)_finishReloadData {
    
    [[[self containerScrollView] mj_header] endRefreshing];
    [[[self containerScrollView] mj_footer] endRefreshing];
}

#pragma mark - accessor

- (ZHMainScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[ZHMainScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
    }
    return _containerScrollView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"home_header"];
        _headerView.layer.masksToBounds = YES;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor yellowColor];
    }
    return _contentView;
}

- (ZHMainTabPagerControllerViewController *)pageController {
    if (!_pageController) {
        _pageController = [[ZHMainTabPagerControllerViewController alloc] init];
    }
    return _pageController;
}

#pragma mark - notification

-(void)notification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat maxOffsetY = 136;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= maxOffsetY) {
        // 滑到顶端
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:kAccessRoofNotification object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        // 离开顶端
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
