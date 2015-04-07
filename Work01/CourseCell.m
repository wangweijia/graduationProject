//
//  CourseCell.m
//  Work01
//
//  Created by kwj on 14/11/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "CourseCell.h"

@interface CourseCell()

//心形按钮
@property (nonatomic,weak) UIButton *collectButton;
//课程名称
@property (nonatomic,weak) UILabel *courseNameLabel;
//教师名称
@property (nonatomic,weak) UILabel *teacherNameLabel;
//课程评分
@property (nonatomic,weak) UILabel *scoreLabel;

@end

@implementation CourseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"course";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        //心形按钮
        UIButton *collect = [[UIButton alloc]init];
//        collect.backgroundColor = [UIColor blueColor];
        collect.frame = CGRectMake(0, 0, 60, 60);
        if (_isCollect) {
            [collect setImage:[UIImage imageNamed:@"course_cell_button_collect"] forState:UIControlStateNormal];
        }else{
            [collect setImage:[UIImage imageNamed:@"course_cell_button"] forState:UIControlStateNormal];
            [collect setImage:[UIImage imageNamed:@"course_cell_button_higlighted"] forState:UIControlStateHighlighted];
        }
        [collect addTarget:self action:@selector(collectButton_Click) forControlEvents:UIControlEventTouchUpInside];//点击事件
        
        [self.contentView addSubview:collect];
        self.collectButton = collect;
        
        //课程名称
        UILabel *name = [[UILabel alloc]init];
//        name.backgroundColor = [UIColor redColor];
        name.frame = CGRectMake(60, 0, 225, 35);
        
        [self.contentView addSubview:name];
        self.courseNameLabel = name;
        
        //教师名称
        UILabel *teacher = [[UILabel alloc]init];
//        teacher.backgroundColor = [UIColor yellowColor];
        teacher.frame = CGRectMake(60, 35, 225, 25);
        
        [self.contentView addSubview:teacher];
        self.teacherNameLabel = teacher;
        
        //课程评分
        UILabel *score = [[UILabel alloc]init];
//        score.backgroundColor = [UIColor greenColor];
        score.frame = CGRectMake(285, 0, 90, 60);
        
        [self.contentView addSubview:score];
        self.scoreLabel = score;
    }
    return self;
}

-(void)setIsCollect:(BOOL)isCollect{
    _isCollect = isCollect;
    if (_isCollect) {
        [_collectButton setImage:[UIImage imageNamed:@"course_cell_button_collect"] forState:UIControlStateNormal];
    }else{
        [_collectButton setImage:[UIImage imageNamed:@"course_cell_button"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"course_cell_button_higlighted"] forState:UIControlStateHighlighted];
    }
}

//设置数据模型   为cell赋值
- (void)setCourse:(Course *)course{
    _course=course;
    
    self.courseNameLabel.text=_course.name;
    self.teacherNameLabel.text=[NSString stringWithFormat:@"教师：%@",_course.teacherName];
    self.scoreLabel.text=[NSString stringWithFormat:@"热门：%d",_course.mark];
}

// button 调用代理方法
-(void)collectButton_Click{
    if ([self.delegates respondsToSelector:@selector(collectButtonClick:)]) {
        
        [self.delegates collectButtonClick:self.course];
        
        _isCollect = !_isCollect;
        if (_isCollect) {
            [_collectButton setImage:[UIImage imageNamed:@"course_cell_button_collect"] forState:UIControlStateNormal];
        }else{
            [_collectButton setImage:[UIImage imageNamed:@"course_cell_button"] forState:UIControlStateNormal];
            [_collectButton setImage:[UIImage imageNamed:@"course_cell_button_higlighted"] forState:UIControlStateHighlighted];
        }
    }
    
//    [self.collectButton setImage:[UIImage imageNamed:@"course_cell_button_collect"] forState:UIControlStateNormal];
}
@end
