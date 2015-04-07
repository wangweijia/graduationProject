//
//  KWJCollectCourseCell.h
//  Work01
//
//  Created by kwj on 14/12/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectCourse.h"

@protocol KWJCollectCourseCellDelegate <NSObject>
@optional
-(void)cellectButtonClick:(CollectCourse *)course;

@end

@interface KWJCollectCourseCell : UITableViewCell

@property (nonatomic)CollectCourse *course;

@property (nonatomic,assign)BOOL isCollect;

@property (nonatomic,weak) id<KWJCollectCourseCellDelegate> delegates;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCourse:(CollectCourse *)course;

@end
