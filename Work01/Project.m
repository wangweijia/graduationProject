//
//  Project.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Project.h"

@implementation Project
+ (instancetype)projectWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        //类别id
        //图标
        //类别名称
        //课程数
        //学习方向 热度
        [self setValuesForKeysWithDictionary:dict];
        
        //2.设置头部默认为关闭
        [self setOpened:false];
    }
    return self;
}

//添加 course 数据模型数据
-(void)setCourseByDictionary:(NSDictionary *)dict{
    Course *course = [Course courseWithDict:dict];
    if (_course == nil) {
        _course = [NSMutableArray array];
    }
    [self.course addObject:course];
}
@end
