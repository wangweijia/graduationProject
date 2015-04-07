//
//  BottomTool.m
//  Work01
//
//  Created by kwj on 14/12/11.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "BottomTool.h"

@interface BottomTool()

@property (nonatomic ,weak) UIButton *promptBtn;

@end

@implementation BottomTool

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        UIButton *btn = [[UIButton alloc] init];
        //设置标题
        [btn setTitle:@"暂无评论,点击添加评论" forState:UIControlStateNormal];
        //标题颜色
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //标题字体
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(promptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.promptBtn = btn;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.promptBtn.frame = self.bounds;
}

/*
 *  按钮点击
 *
 *  @param sender button
 */
-(void)promptBtnClick:(UIButton *)sender{
    if ([self.delegates respondsToSelector:@selector(bottomBoolClicked:)]) {
        [self.delegates bottomBoolClicked:sender];
    }
}

/*
 *  设置按钮标题
 *
 *  @param title 标题
 */
-(void)setBtnTitle:(NSString *)title{
    [_promptBtn setTitle:title forState:UIControlStateNormal];
}


@end
