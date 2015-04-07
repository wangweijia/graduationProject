//
//  KWJCommentFrame.h
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KWJComment.h"

/* 昵称的字体 */
#define CommentNameFont [UIFont systemFontOfSize:15]
/* 时间的字体 */
#define CommentTimeFont [UIFont systemFontOfSize:10]
/* 正文的字体 */
#define CommentContentFont [UIFont systemFontOfSize:13]

/* 表格的边框宽度 */
#define TableBorder 5
/* cell的边框宽度 */
#define CellBorder 10

@interface KWJCommentFrame : NSObject

@property (nonatomic,strong) KWJComment *comment;

/* 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;

/* 头像 */
@property (nonatomic, assign, readonly) CGRect nameViewF;

/* 头像 */
@property (nonatomic, assign, readonly) CGRect timeViewF;

/* 头像 */
@property (nonatomic, assign, readonly) CGRect contentViewF;

@property (nonatomic, assign, readonly) CGFloat cellH;

@end
