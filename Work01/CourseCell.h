//
//  CourseCell.h
//  Work01
//
//  Created by kwj on 14/11/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@protocol courseCellDelegate <NSObject>
@optional
-(void)collectButtonClick:(Course *)course;

@end
@interface CourseCell : UITableViewCell

@property (nonatomic)Course *course;

@property (nonatomic,assign)BOOL isCollect;

@property (nonatomic,weak) id<courseCellDelegate> delegates;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCourse:(Course *)course;
@end
