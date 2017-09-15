# TYPagerController-ZHScrollViewNestPagerController
基于 TYPagerController 实现 UIScrollView 上嵌入多个 UIViewController,点击标签控制器切换视图控制器的,也可左右滑动,实现标签控制器悬停,效果图如下:

![59ba4f00f1279.gif](https://i.loli.net/2017/09/14/59ba4f00f1279.gif)
## Features
基于 TYPagerController 的 TYTabPagerController 实现此功能,点击标签控制器切换到不同的试图控制器,可以左右滑动
>嵌入不同试图控制器

```
- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching;
```
## How to use
TYPagerController 简单,强大,高度定制,页面控制器,水平滚动内容和标题栏,包含多种 barStyle
TYPagerController 具体用方详见: 
<https://github.com/12207480/TYPagerController>
### Installation
```
pod 'TYPagerController'
```
### Initialization
##### create subviews
```
@property (nonatomic, strong) ZHMainTabPagerControllerViewController *pageController;
@property (nonatomic, strong) ZHMainScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *contentView;
```
```
[[self view] addSubview:[self containerScrollView]];
[[self containerScrollView] addSubview:[self headerView]];
[[self containerScrollView] addSubview:[self contentView]];
[[self contentView] addSubview:[[self pageController] view]];
```
##### register notification
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAccessRoofNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kAwayRoofNotification object:nil];
```
##### UIScrollViewDelegate
```
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
```
## Thank you for reviewing




