//
//  KWJAccount.h
//  Work01
//
//  Created by kwj on 14/12/3.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWJAccount : NSObject<NSCoding>

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, strong) NSDate *expiresTime; // 账号的过期时间
// 如果服务器返回的数字很大, 建议用long long(比如主键, ID)
@property (nonatomic, assign) long long expires_in;
@property (nonatomic, assign) long long remind_in;
@property (nonatomic, assign) long long uid;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dict;

@end
