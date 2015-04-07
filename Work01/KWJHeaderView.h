//
//  KWJHeaderView.h
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWJHeaderView,Project;

@protocol KWJHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(KWJHeaderView *)headerView;
@end

@interface KWJHeaderView : UITableViewHeaderFooterView

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<KWJHeaderViewDelegate> delegates;
@property (nonatomic,strong) Project *project;
@end
