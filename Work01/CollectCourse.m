
//  CollectCourse.m
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "CollectCourse.h"

@interface CollectCourse()


@end

@implementation CollectCourse

+ (NSArray *)courseWithStmt:(sqlite3_stmt *)stmt{
    
    NSMutableArray *collectArray = [NSMutableArray array];
    
    do{
        if (stmt == NULL) {
           return collectArray;
        }
//        NSLog(@"SQLITE_ROW");
        // 获得这行对应的数据
        CollectCourse *course = [[self alloc] init];
        
        // 获得第2列的id
        course.teacherName = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        // 获得第3列的id
        course.courseId = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        // 获得第4列的id
        course.name = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
        // 获得第5列的id
        course.userId = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
        
        [collectArray addObject:course];
    }while(sqlite3_step(stmt) == SQLITE_ROW);
    
    return collectArray;
}


@end
