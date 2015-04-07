//
//  KWJStudyInfoCell.h
//  Work01
//
//  Created by kwj on 15/1/12.
//  Copyright (c) 2015年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyInfo;

@interface KWJStudyInfoCell : UITableViewCell

@property (nonatomic,strong) StudyInfo *studyInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setStudyInfo:(StudyInfo *)studyInfo;

@end
