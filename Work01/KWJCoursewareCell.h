//
//  KWJCoursewareCellCell.h
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCourseware.h"

@interface KWJCoursewareCell : UITableViewCell

@property (nonatomic,strong)MyCourseware *courseware;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
