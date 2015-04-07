//
//  KWJPublishToolView.m
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJPublishToolView.h"
#import "HeaderFile.h"

@interface KWJPublishToolView()

@property (nonatomic,weak) UIButton *photoBtn;

@property (nonatomic,weak) UIButton *friendBtn;

@property (nonatomic,weak) UIButton *activityBtn;

@property (nonatomic,strong) NSMutableArray *btnArray;

@end

@implementation KWJPublishToolView

-(id)initWith:(allBtnClick)allButtonClick{
    if (self = [super init]) {
        
        _btnArray = [NSMutableArray array];
        
        //Block
        _allbtnclick = allButtonClick;
        
        self.backgroundColor = KWJColor(209, 209, 209);
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoBtn setTitle:@"图" forState:UIControlStateNormal];
        photoBtn.tag = 10001;
        [photoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:photoBtn];
        [_btnArray addObject:photoBtn];
        self.photoBtn = photoBtn;
        
        UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [friendBtn setTitle:@"@" forState:UIControlStateNormal];
        friendBtn.tag = 10002;
        [friendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:friendBtn];
        [_btnArray addObject:friendBtn];
        self.friendBtn = friendBtn;
        
        UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [activityBtn setTitle:@"#" forState:UIControlStateNormal];
        activityBtn.tag = 10003;
        [activityBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:activityBtn];
        [_btnArray addObject:activityBtn];
        self.activityBtn = activityBtn;
    }
    return self;
}

-(id)initWith:(allBtnClick)allButtonClick button:(NSArray *)btn{
    if (self == [super init]) {
        for (int i = 0; i < btn.count; i++) {
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [Btn setTitle:btn[i] forState:UIControlStateNormal];
            Btn.tag = 10001 + i;
            [Btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:Btn];
            [_btnArray addObject:Btn];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat BtnH = self.frame.size.height;
    CGFloat BtnW = 60;
    CGFloat BtnY = 0;
    
    for (int i = 0 ; i < _btnArray.count ; i++) {
        UIButton *btn = _btnArray[i];
        CGFloat BtnX = i * BtnW;
        btn.frame = CGRectMake(BtnX, BtnY, BtnW, BtnH);
    }
}

-(void)BtnClick:(UIButton *)sender{
    if (_allbtnclick != nil) {
        _allbtnclick(sender);
    }
}

@end
