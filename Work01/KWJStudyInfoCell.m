//
//  KWJStudyInfoCell.m
//  Work01
//
//  Created by kwj on 15/1/12.
//  Copyright (c) 2015年 wwj. All rights reserved.
//

#import "KWJStudyInfoCell.h"
#import "StudyInfo.h"

@interface KWJStudyInfoCell()


@end

@implementation KWJStudyInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"info";
    KWJStudyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJStudyInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setStudyInfo:(StudyInfo *)studyInfo{
    _studyInfo = studyInfo;
    self.textLabel.text = [NSString stringWithFormat:@"%@",studyInfo.courseName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@年%@月%@日  开始:%@  结束:%@",studyInfo.studyYear,studyInfo.studyMonth,studyInfo.studyDay,studyInfo.studyBegin,studyInfo.studyEnd];
}

@end
