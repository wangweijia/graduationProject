//
//  KWJStatusUser.m
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusUser.h"

@implementation KWJStatusUser

+(instancetype)userWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.idstr = dic[@"idstr"];
        self.name = dic[@"name"];
        self.profile_image_url = dic[@"profile_image_url"];

        self.mbrank = [dic[@"mbrank"] intValue];
    }
    return self;
}

@end
