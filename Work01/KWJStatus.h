//
//  KWJStatus.h
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KWJStatusUser;

@interface KWJStatus : NSObject
/*内容文字*/
@property (nonatomic,copy) NSString *text;
/*微博来源*/
@property (nonatomic,copy) NSString *source;
/*微博的时间*/
@property (nonatomic, copy) NSString *created_at;
/*微博的ID*/
@property (nonatomic,copy) NSString *idstr;
/*转发量*/
@property (nonatomic,assign) int reposts_count;
/*评论数*/
@property (nonatomic,assign) int comments_count;
/*微博的表态数(被赞数)*/
@property (nonatomic,assign) int attitudes_count;
/*微博的用户*/
@property (nonatomic,strong) KWJStatusUser *user;
/*被转发的微博*/
@property (nonatomic, strong) KWJStatus *retweeted_status;
/*发送图片*/
@property (nonatomic,copy) NSString *thumbnail_pic;
@property (nonatomic,strong) NSMutableArray *pic_urls;

@property (nonatomic,copy) NSString *xmlPath;
@property (nonatomic,copy) NSString *xmlName;

+ (instancetype)statusWithDic:(NSDictionary *)dic;

- (id)initWithDic:(NSDictionary *)dic;
@end
/*
 source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 status	        true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 visible	    false	int	    微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 list_id	    false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 lat	        false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 long	        false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 annotations	false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
 rip	        false	string  开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
