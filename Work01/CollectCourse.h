//
//  CollectCourse.h
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CollectCourse : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *courseId;
@property (nonatomic,copy) NSString *teacherName;

+ (NSArray *)courseWithStmt:(sqlite3_stmt *)stmt;

@end
/*
 dic[@"name"]         = @"text";
 dic[@"userId"]       = @"text";
 dic[@"courseId"]     = @"text";
 dic[@"access_token"] = @"text";
 [self.collect creatTabel:@"t_collect" key:dic];
 */