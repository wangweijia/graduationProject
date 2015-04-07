//
//  KWJAccountTool.m
//  Work01
//
//  Created by kwj on 14/12/3.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJAccountTool.h"
#import "KWJAccount.h"

#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation KWJAccountTool
+ (void)saveAccount:(KWJAccount *)account
{
    // 计算账号的过期时间
    NSDate *now = [NSDate date];
    account.expiresTime = [now dateByAddingTimeInterval:account.expires_in];
    
    [NSKeyedArchiver archiveRootObject:account toFile:IWAccountFile];
}

+ (KWJAccount *)account
{
    // 取出账号
    KWJAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    
    // 判断账号是否过期
    NSDate *now = [NSDate date];
    if ([now compare:account.expiresTime] == NSOrderedAscending) { // 还没有过期
        return account;
    } else { // 过期
        return nil;
    }
}
@end
