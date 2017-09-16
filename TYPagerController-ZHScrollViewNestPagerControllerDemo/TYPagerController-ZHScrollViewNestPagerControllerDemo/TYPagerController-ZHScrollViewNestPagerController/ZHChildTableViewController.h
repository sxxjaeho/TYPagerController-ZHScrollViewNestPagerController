//
//  ZHChildTableViewController.h
//  TYPagerController-ZHScrollViewNestPagerController
//
//  Created by Zeaho on 2017/9/14.
//  Copyright © 2017年 Zeaho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHChildTableViewControllerDelegate <NSObject>

- (void)loadMoreData;

@end

@interface ZHChildTableViewController : UITableViewController

@property (nonatomic, assign) id<ZHChildTableViewControllerDelegate> extensionDelegate;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)refreshWithData:(NSArray *)data;

- (void)loadMoreData;

@end
