//
//  KWJCommentCell.h
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJComment.h"
#import "KWJCommentFrame.h"

@interface KWJCommentCell : UITableViewCell

//数据模型
@property (nonatomic,strong) KWJComment *comment;

//cell 尺寸
@property (nonatomic,strong) KWJCommentFrame *commentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
