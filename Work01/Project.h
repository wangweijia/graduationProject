//
//  Project.h
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
/*
 *  选择领域  页面的数据模型
 */
@interface Project : NSObject

@property (nonatomic) int typeId;             //类别id
@property (nonatomic,copy) NSString *name;    //类别名称
@property (nonatomic,copy) NSString *logoPath;//图标
@property (nonatomic) int count;              //课程数
@property (nonatomic) int hot;                //学习方向 热度

@property (nonatomic) int page;               //数据请求 分页 页数

@property (nonatomic) NSMutableArray *course;        //开设的课程

//是否 展开选课列表
@property (nonatomic,assign,getter=isOpened) BOOL opened;

+ (instancetype)projectWithDict:(NSDictionary *)dict;

-(void)setCourseByDictionary:(NSDictionary *)dict;
@end
