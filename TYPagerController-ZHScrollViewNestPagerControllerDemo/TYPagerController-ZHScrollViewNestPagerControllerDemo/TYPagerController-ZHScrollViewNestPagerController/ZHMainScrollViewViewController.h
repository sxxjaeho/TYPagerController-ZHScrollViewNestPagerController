//
//  ZHMainScrollViewViewController.h
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMainTabPagerControllerViewController.h"
#import "ZHMainScrollView.h"

@interface ZHMainScrollViewViewController : UIViewController

@property (nonatomic, strong, readonly) ZHMainTabPagerControllerViewController *pageController;
@property (nonatomic, strong, readonly) ZHMainScrollView *containerScrollView;
@property (nonatomic, strong, readonly) UIImageView *headerView;
@property (nonatomic, strong, readonly) UIView *contentView;

@end
