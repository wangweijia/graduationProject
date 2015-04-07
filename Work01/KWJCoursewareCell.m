//
//  KWJCoursewareCellCell.m
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJCoursewareCell.h"

@implementation KWJCoursewareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"courseware";
    KWJCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJCoursewareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置cell背景图片
        UIImageView *bgImage = [[UIImageView alloc]init];
        bgImage.frame = self.bounds;
        bgImage.image = [UIImage imageNamed:@"course_cell_bg"];
        self.backgroundView = bgImage;
        //cell选中时的反应
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setCourseware:(MyCourseware *)courseware{
    self.textLabel.text = courseware.coursewareName;
    self.detailTextLabel.text = courseware.coursewareTitle;
}

@end
