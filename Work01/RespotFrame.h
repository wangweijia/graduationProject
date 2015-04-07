//
//  RespotFrame.h
//  Work01
//
//  Created by kwj on 14/12/13.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KWJStatus.h"

#define TableBorder 10

/* 转发感想的字体 */
#define RespotFont [UIFont systemFontOfSize:15]
/* 昵称的字体 */
#define NameFont [UIFont systemFontOfSize:15]
/* 正文的字体 */
#define StatusContentFont [UIFont systemFontOfSize:10]

@interface RespotFrame : NSObject

@property (nonatomic, strong) KWJStatus *status;

@property (nonatomic, assign) CGFloat selfW;

@property (nonatomic, assign, readonly) CGRect respotF;

@property (nonatomic, assign, readonly) CGRect textViewF;

@property (nonatomic, assign, readonly) CGRect photoViewF;

@property (nonatomic, assign, readonly) CGRect statusViewF;

@property (nonatomic, assign, readonly) CGRect nameLabelF;

@property (nonatomic, assign, readonly) CGRect statusLabelF;

@end
