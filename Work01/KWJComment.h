//
//  KWJComment.h
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KWJStatusUser.h"

@interface KWJComment : NSObject

//返回值字段	字段类型	字段说明
//created_at	string	评论创建时间
@property (nonatomic,copy) NSString *created_at;

//id	int64	评论的ID

//text	string	评论的内容
@property (nonatomic,copy) NSString *text;

//source	string	评论的来源

//user	object	评论作者的用户信息字段 详细
@property (nonatomic,strong) KWJStatusUser *user;

//mid	string	评论的MID

//idstr	string	字符串型的评论ID
@property (nonatomic,copy) NSString *idstr;

//status	object	评论的微博信息字段 详细

//reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段

+ (instancetype)commentWithDic:(NSDictionary *)dic;

- (id)initWithDic:(NSDictionary *)dic;

- (NSMutableAttributedString *)contents;

@end
