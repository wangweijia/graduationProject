//
//  KWJStatusCell.m
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusCell.h"
#import "KWJStatusFrame.h"
#import "KWJStatusUser.h"
#import "KWJStatus.h"
#import "KWJTopView.h"
//公用 宏头文件
#import "HeaderFile.h"

@interface KWJStatusCell()

/* 顶部的view */
@property (nonatomic, weak) KWJTopView *topView;

/* 微博的工具条 */
@property (nonatomic, weak) KWJStatusToolBar *statusToolbar;

@end

@implementation KWJStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    KWJStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell选中时的背景
        self.selectedBackgroundView = [[UIView alloc]init];
        
        //添加顶部控件
        [self setupStatusTopView];
        
        //添加微博的工具条
        [self setupStatusToolBar];
    }
    return self;
}

// 设置代理
- (void)setStatusToolBarDelegate:(id)object{
    self.statusToolbar.delegates = object;
}

// 2.添加微博的topview控件
-(void)setupStatusTopView{
    KWJTopView *topView = [[KWJTopView alloc]init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}

// 3.添加微博的工具条
-(void)setupStatusToolBar{
    /* 微博的工具条 */
    KWJStatusToolBar *statusToolbar = [[KWJStatusToolBar alloc]init];
    [self.contentView addSubview:statusToolbar];
    self.statusToolbar = statusToolbar;
}

/*
 *  传递模型数据
 */
- (void)setStatusFrame:(KWJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 2.添加微博Topview 赋值
    [self setupStatusTopview];
    
    // 3.添加微博的工具条 赋值
    [self setupStatusToolbar];
}

/*
 *  topvie初始化
 */
-(void)setupStatusTopview{
    self.topView.frame = self.statusFrame.topViewF;
    self.topView.statusFrame = self.statusFrame;
}

/*
 *  工具条初始化
 */
-(void)setupStatusToolbar{
    self.statusToolbar.frame = self.statusFrame.statusToolbarF;
    self.statusToolbar.status = self.statusFrame.status;
}

/*
 *  拦截 frame 赋值
 */
-(void)setFrame:(CGRect)frame{
    frame.origin.y += statusTableBorder;
    frame.origin.x = statusTableBorder;
    frame.size.width -= 2 * statusTableBorder;
    frame.size.height -= (statusTableBorder + 10);
    
    [super setFrame:frame];
}

@end
