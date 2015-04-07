//
//  KWJStatusFrame.h
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class KWJStatus;

/* 昵称的字体 */
#define statusNameFont [UIFont systemFontOfSize:15]
/* 时间的字体 */
#define statusTimeFont [UIFont systemFontOfSize:12]
/* 来源的字体 */
#define statusSourceFont statusTimeFont
/* 正文的字体 */
#define statusContentFont [UIFont systemFontOfSize:13]


/* 表格的边框宽度 */
#define statusTableBorder 5
/* cell的边框宽度 */
#define statusCellBorder 10


@interface KWJStatusFrame : NSObject

/*数据模型*/
@property (nonatomic,strong) KWJStatus *status;

/* 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
/* 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/* 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;
/* 配图 */
@property (nonatomic, assign, readonly) CGRect photoViewF;
/* 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/* 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/* 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/* 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/* 被转发微博的view(父控件) */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/* 被转发微博作者的昵称 */
@property (nonatomic, assign, readonly) CGRect retweetNameLabelF;
/* 被转发微博的正文\内容 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;
/* 被转发微博的配图 */
@property (nonatomic, assign, readonly) CGRect retweetPhotoViewF;

/* 微博的工具条 */
@property (nonatomic, assign, readonly) CGRect statusToolbarF;

/* cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, assign, readonly) CGFloat cellHeight_topView;

@end
