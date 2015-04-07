//
//  KWJSoreByInitial.m
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJSoreByInitial.h"
#import "KWJFriends.h"
#import "pinyin.h"

@interface KWJSoreByInitial()

@property (nonatomic,strong) NSMutableDictionary *letterDic;

@property (nonatomic,strong) NSArray *array;

@end

@implementation KWJSoreByInitial

+(NSDictionary *)sortByInitial:(NSArray *)array{
    KWJSoreByInitial *sort = [[KWJSoreByInitial alloc]initSortByInitial:array];
    [sort startSort];
    return sort.letterDic;
}

-(id)initSortByInitial:(NSArray *)array{
    if (self = [super init]) {
        _letterDic = [NSMutableDictionary dictionary];
        _array = array;
    }
    return self;
}

-(void)startSort{
    for (KWJFriends *f in _array) {
        NSString *screen_name = f.screen_name;
        NSString *str = [NSString stringWithFormat:@"%c",pinyinFirstLetter([screen_name characterAtIndex:0])];
        
        if ([str isEqualToString:@"#"]) {
            //昵称非汉字开头
            NSString *ch = [screen_name substringWithRange:NSMakeRange(0, 1)];
            str = [ch lowercaseString];
        }
        
        if (_letterDic[str] == nil) {
            NSMutableArray *cArray = [NSMutableArray array];
            [cArray addObject:f];
            _letterDic[str] = cArray;
        }else{
            NSMutableArray *cArray = _letterDic[str];
            [cArray addObject:f];
            //            _letterDic[str] = cArray;
        }

    }
}


@end

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */

