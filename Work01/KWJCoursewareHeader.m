//
//  KWJCoursewareHeader.m
//  Work01
//
//  Created by kwj on 14/12/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJCoursewareHeader.h"

@interface KWJCoursewareHeader()

@property (nonatomic,weak)UIButton *wordBtn;

@property (nonatomic,weak)UIButton *pptBtn;

@property (nonatomic,weak)UIButton *pdfBtn;

@property (nonatomic,strong)NSMutableArray *btnArray;


@end

@implementation KWJCoursewareHeader

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    //创建头部控件
    static NSString *ID = @"head";
    KWJCoursewareHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (header == nil) {
        header = [[KWJCoursewareHeader alloc] initWithReuseIdentifier:ID];
    }
    
    return header;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.wordBtn = [self creatBtn:@"WORD" image:@"words"];
        self.wordBtn.tag = 10000;
        self.pptBtn = [self creatBtn:@"PPT" image:@"ppts"];
        self.pptBtn.tag = 10001;
        self.pdfBtn = [self creatBtn:@"PDF" image:@"pdfs"];
        self.pdfBtn.tag = 10002;
//        self.selectedBtn = self.wordBtn;
        [self.selectedBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    return self;
}

-(UIButton *)creatBtn:(NSString *)title image:(NSString *)image{
    
    if (self.btnArray == nil) {
        self.btnArray = [NSMutableArray array];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    if (image) {
//        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    }
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArray addObject:btn];
    [self addSubview:btn];
    return btn;
}

-(void)btnClick:(UIButton *)sender{
    if ([self.delegates respondsToSelector:@selector(headerBtnClick:)]) {
        
        [self.delegates headerBtnClick:sender];
        self.selectedBtn = sender;
    }
}

-(void)setSelectedBtnWithTag:(int)tag{
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedBtn = self.btnArray[tag - 10000];
    [_selectedBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat wide = self.frame.size.width;
    CGFloat btnW = wide / _btnArray.count;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    
    for (int i = 0; i < _btnArray.count; i++) {
        CGFloat btnX = i * btnW;
        ((UIButton *)_btnArray[i]).frame = CGRectMake(btnX, btnY, btnW, btnH);
//        ((UIButton *)_btnArray[i]).tag = 10000 + i;
    }
}

@end
