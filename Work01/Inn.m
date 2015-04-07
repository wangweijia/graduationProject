//
//  Inn.m
//  Work01
//
//  Created by kwj on 14/11/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Inn.h"

@implementation Inn

-(id)init{
    if (self = [super init]) {
        _innArray = [NSMutableArray array];
    }
    return self;
}

//1.入栈
-(void)push:(id)object{
    
    [_innArray addObject:object];
}
//2.出栈
-(void)pop{
    NSUInteger n = _innArray.count;
    if (n > 0) {
        NSObject *obj = _innArray[n-1];
        [_innArray  removeObject:obj];
    }
}
//3.输出栈顶元素
-(id)getTopObject{
    NSUInteger n = _innArray.count;
    if (n > 0) {
        return _innArray[n-1];
    }
    return nil;
}
//4.得到栈中数据个数
-(int)countOfInnArray{
    return (int)_innArray.count;
}

@end
