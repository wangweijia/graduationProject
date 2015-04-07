//
//  MyCourseware.m
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "MyCourseware.h"

@implementation MyCourseware

+ (NSMutableArray *)CoursewareWithStmt:(sqlite3_stmt *)stmt{
    
    NSMutableArray *coursewareArray = [NSMutableArray array];
    
    do{
        if (stmt == NULL) {
            return coursewareArray;
        }
        MyCourseware *courseware = [[self alloc] init];
        
        // 获得第1列的id
        courseware.coursewareId = (int)sqlite3_column_int(stmt,0);
        // 获得第2列的id
        courseware.filePath = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        // 获得第3列的id
        courseware.coursewareType = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        // 获得第4列的id
        courseware.coursewareName = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
        // 获得第5列的id
        courseware.courseId = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
        // 获得第6列的id
        courseware.coursewareTitle = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
        // 获得第7列的id
        courseware.access_token = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
        
        [coursewareArray addObject:courseware];
    }while(sqlite3_step(stmt) == SQLITE_ROW);
    
    return coursewareArray;
}

@end
/*
 @property (nonatomic,copy)NSString *coursewareName;
 @property (nonatomic,copy)NSString *coursewareType;
 @property (nonatomic,copy)NSString *access_token;
 @property (nonatomic,copy)NSString *courseId;
 @property (nonatomic,copy)NSString *filePath;
 */