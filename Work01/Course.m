//
//  Course.m
//  Work01
//
//  Created by kwj on 14/11/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Course.h"

@implementation Course

+ (instancetype)courseWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
