//
//  KWJSectionHeaderView.h
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstLevel.h"
@class KWJSectionHeaderView;

@protocol KWJSectionHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedMainView:(KWJSectionHeaderView *)headerView;

@end

@interface KWJSectionHeaderView : UITableViewHeaderFooterView

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) FirstLevel *first;

@property (nonatomic,weak) id<KWJSectionHeaderViewDelegate> delegates;

@end
