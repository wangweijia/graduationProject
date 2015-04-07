//
//  KWJPhoto.m
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJPhoto.h"

@implementation KWJPhoto

+ (instancetype)photoWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.thumbnail_pic = dic[@"thumbnail_pic"];
    }
    return self;
}

@end
