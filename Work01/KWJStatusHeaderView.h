//
//  KWJStatusHeaderView.h
//  Work01
//
//  Created by kwj on 14/12/12.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopTool.h"
#import "BottomTool.h"
#import "KWJStatus.h"

@interface KWJStatusHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) KWJStatus *status;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView topToolDelegate:(id)object;

- (void)setSelectBtn:(NSInteger)tag;

@end
