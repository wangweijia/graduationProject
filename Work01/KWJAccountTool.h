//
//  KWJAccountTool.h
//  Work01
//
//  Created by kwj on 14/12/3.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWJAccount;

@interface KWJAccountTool : NSObject
/*
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(KWJAccount *)account;

/*
 *  返回存储的账号信息
 */
+ (KWJAccount *)account;
@end
