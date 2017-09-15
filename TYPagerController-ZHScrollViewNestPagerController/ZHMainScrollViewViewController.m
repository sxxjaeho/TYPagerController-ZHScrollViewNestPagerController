//
//  ZHMainScrollViewViewController.m
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "ZHMainScrollViewViewController.h"
#import "ZHMainTabPagerControllerViewController.h"
#import "ZHMainScrollView.h"
#import "ZHChildTableViewController.h"

@interface ZHMainScrollViewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) ZHMainTabPagerControllerViewController *pageController;
@property (nonatomic, strong) ZHMainScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *contentView;

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
    
    _canScroll = YES;
    
    [self _createSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAwayRoofNotification object:nil];
}

#pragma mark - accessor

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
