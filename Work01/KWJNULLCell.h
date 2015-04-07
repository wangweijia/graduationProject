//
//  KWJNULLCell.h
//  Work01
//
//  Created by kwj on 14/12/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWJNULLCell : UITableViewCell

@property (nonatomic,copy)NSString *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
