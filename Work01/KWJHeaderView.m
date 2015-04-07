//
//  KWJHeaderView.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJHeaderView.h"
#import "Project.h"

@interface KWJHeaderView()

@property (nonatomic,weak) UIButton *nameView;
@property (nonatomic,weak) UILabel *countView;

@end

@implementation KWJHeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    //创建头部控件
    static NSString *ID = @"head";
    KWJHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (header == nil) {
        header = [[KWJHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    return header;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //添加子控件
        //按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置背景图片
        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        //设置按钮内部的箭头图片
        [nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置按钮内容居左
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置按钮的内边距
        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [nameView addTarget:self action:@selector(nameView_Click) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮内部的imageView的内容模式为居中
        nameView.imageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不需要裁剪
        nameView.imageView.clipsToBounds = NO;
        
        [self.contentView addSubview:nameView];
        self.nameView=nameView;
        
        //课程数
        UILabel *countView = [[UILabel alloc]init];
        
        countView.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:countView];
        self.countView=countView;
    }
    return self;
}

/*
 *  设置 数据模型
 *
 */
- (void)setProject:(Project *)project
{
    _project = project;
    
    // 1.设置按钮文字(组名)
    [self.nameView setTitle:_project.name forState:UIControlStateNormal];
    
    // 2.设置课程数
    self.countView.text = [NSString stringWithFormat:@"%d 门课程", _project.count];
}

/*
 *   当一个控件的frame发生变化时调用
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameView.frame=self.bounds;
//    NSLog(@"dsfsfsdfd%@",NSStringFromCGRect(self.nameView.frame));
    
    CGFloat countY = 0;
    CGFloat countH = self.frame.size.height;
    CGFloat countW = 100;
    CGFloat countX = self.frame.size.width - 10 - countW;
    
    self.countView.frame = CGRectMake(countX,countY,countW, countH);
    
}

/*
 *  头部控件的点击事件
 */
-(void)nameView_Click{
    // 1.修改组模型的标记(状态取反)
    self.project.Opened=!self.project.isOpened;
    
    // 2.刷新表格
    if ([self.delegates respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        [self.delegates headerViewDidClickedNameView:self];
    }
}

/*
 *  当一个控件被添加到父控件中就会调用
 */
- (void)didMoveToSuperview
{
    if (self.project.isOpened) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}
@end
