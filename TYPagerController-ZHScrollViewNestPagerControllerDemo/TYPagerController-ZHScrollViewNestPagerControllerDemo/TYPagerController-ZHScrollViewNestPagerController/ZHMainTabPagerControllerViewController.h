//
//  ZHMainTabPagerControllerViewController.h
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import "TYTabPagerController.h"
#import "ZHChildTableViewController.h"

@interface ZHMainTabPagerControllerViewController : TYTabPagerController

@property (nonatomic, copy) void (^loadMoreDataHandler)(NSInteger index);

@property (nonatomic, strong, readonly) ZHChildTableViewController *firstChildTableViewController;

@property (nonatomic, strong, readonly) ZHChildTableViewController *secondChildTableViewController;

@property (nonatomic, strong) NSMutableDictionary *dataSourceDictionary;

@end
