//
//  SecondLevel.m
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SecondLevel.h"
#import "Courseware.h"

@implementation SecondLevel

+(instancetype)secondLevelWithArray:(NSArray *)array{
    SecondLevel *secondl = [[SecondLevel alloc]initWithArray:array];
    
    return secondl;
}

-(id)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        
        _word = [NSMutableArray array];
        _ppt = [NSMutableArray array];
        _video = [NSMutableArray array];
        _pdf = [NSMutableArray array];
        
        _title = ((NSDictionary *)array[0])[@"title"];
        _subtitle = ((NSDictionary *)array[1])[@"subtitle"];
        
        for (int i = 2; i < array.count; i++) {
            NSDictionary *temp = array[i];
            
            NSString *key = [temp allKeys][0];
            
            if ([key isEqualToString:@"word"]) {
                [_word addObject:[Courseware coursewareWithArray:temp[key]]];
            }else if ([key isEqualToString:@"ppt"]){
                [_ppt addObject:[Courseware coursewareWithArray:temp[key]]];
            }else if ([key isEqualToString:@"video"]){
                [_video addObject:[Courseware coursewareWithArray:temp[key]]];
            }else if ([key isEqualToString:@"pdf"]){
                [_pdf addObject:[Courseware coursewareWithArray:temp[key]]];
            }
        }
    }
    return self;
}
@end
