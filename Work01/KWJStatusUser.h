//
//  KWJStatusUser.h
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWJStatusUser : NSObject
/*用户ID*/
@property (nonatomic,copy) NSString *idstr;
/*用户的名称*/
@property (nonatomic,copy) NSString *name;
/*用户头像*/
@property (nonatomic,copy) NSString *profile_image_url;
/*是否为vip*/
//@property (nonatomic, assign, getter = isVip) BOOL vip;

/*
 *  会员等级
 */
@property (nonatomic, assign) int mbrank;

+(instancetype)userWithDic:(NSDictionary *)dic;

-(id)initWithDic:(NSDictionary *)dic;
@end
