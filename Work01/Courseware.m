//
//  Courseware.m
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Courseware.h"

@implementation Courseware

+(instancetype)coursewareWithArray:(NSArray *)array{
    Courseware *courseware = [[Courseware alloc]initWithArray:array];
    
    return courseware;
}

-(id)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        _title = ((NSDictionary *)array[0])[@"title"];
        _path = ((NSDictionary *)array[1])[@"path"];
    }
    return self;
}

@end
