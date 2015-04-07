//
//  KWJStatusCell.h
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJStatusToolBar.h"

@class KWJStatusFrame;

@interface KWJStatusCell : UITableViewCell

@property (nonatomic,strong)KWJStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setStatusToolBarDelegate:(id)object;

@end
