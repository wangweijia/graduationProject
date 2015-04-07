//
//  Course.h
//  Work01
//
//  Created by kwj on 14/11/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *teacherName;
@property (nonatomic) int mark;
@property (nonatomic,copy) NSString *courseId;
@property (nonatomic,copy) NSString *type;//区分课程类型（暂时无用）

+ (instancetype)courseWithDict:(NSDictionary *)dict;
@end
