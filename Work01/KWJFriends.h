//
//  KWJFriends.h
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWJFriends : NSObject

@property (nonatomic,copy) NSString *idstr;

@property (nonatomic,copy) NSString *screen_name;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *profile_image_url;

@property (nonatomic,assign) BOOL verified;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,assign) int online_status;

@property (nonatomic) BOOL isSelected;

+ (instancetype)friendsWithDict:(NSDictionary *)dict;

- (id)initWithDict:(NSDictionary *)dict;

@end
/*
 id	                int64	用户UID
 idstr	            string	字符串型的用户UID
 screen_name	    string	用户昵称
 name	            string	友好显示名称
 profile_image_url	string	用户头像地址（中图），50×50像素
 domain	            string	用户的个性化域名
 weihao	            string	用户的微号
 gender	            string	性别，m：男、f：女、n：未知
 verified	        boolean	是否是微博认证用户，即加V用户，true：是，false：否
 remark	            string	用户备注信息，只有在查询用户关系时才返回此字段
 online_status	    int	    用户的在线状态，0：不在线、1：在线
 */
