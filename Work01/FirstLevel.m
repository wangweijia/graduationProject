//
//  FirstLevel.m
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "FirstLevel.h"
#import "SecondLevel.h"

@implementation FirstLevel

+(instancetype)firstLevelWithArray:(NSArray *)array{
    FirstLevel *firstl = [[FirstLevel alloc]initWithArray:array];
    
    [firstl setOpened:false];
    
    return firstl;
}

-(id)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        _title = ((NSDictionary *)array[0])[@"title"];
        _subtitle = ((NSDictionary *)array[1])[@"subtitle"];
        _secondLevel = [NSMutableArray array];
        
        for (int i =2; i<array.count; i++) {
            NSArray *tempArray = ((NSDictionary *)array[i])[@"secondLevel"];
            [_secondLevel addObject:[SecondLevel secondLevelWithArray:tempArray]];
        }
    }
    return self;
}

@end
