//
//  StudyInfo.m
//  Work01
//
//  Created by kwj on 15/1/12.
//  Copyright (c) 2015年 wwj. All rights reserved.
//

#import "StudyInfo.h"

@implementation StudyInfo

+ (NSMutableArray *)StudyInfoWithStmt:(sqlite3_stmt *)stmt{
    
    NSMutableArray *coursewareArray = [NSMutableArray array];
    
    do{
        if (stmt == NULL) {
            return coursewareArray;
        }
        StudyInfo *studyInfo = [[self alloc] init];
        
        studyInfo.studyDay = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        studyInfo.studyTime = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        studyInfo.courseId = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
        studyInfo.studyEnd = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
        studyInfo.studyYear = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
        studyInfo.studyMonth = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
        studyInfo.courseName = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
        studyInfo.studyBegin = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 9) encoding:NSUTF8StringEncoding];
        
        // 获得第1列的id
//        courseware.coursewareId = (int)sqlite3_column_int(stmt,0);
//        // 获得第2列的id
//        courseware.filePath = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//        // 获得第3列的id
//        courseware.coursewareType = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
//        // 获得第4列的id
//        courseware.coursewareName = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
//        // 获得第5列的id
//        courseware.courseId = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
//        // 获得第6列的id
//        courseware.coursewareTitle = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
//        // 获得第7列的id
//        courseware.access_token = [[NSString alloc] initWithCString:(const char *)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
//        
        [coursewareArray addObject:studyInfo];
    }while(sqlite3_step(stmt) == SQLITE_ROW);
    
    return coursewareArray;
}

@end

/*
 @property (nonatomic,copy) NSString *courseName;
 @property (nonatomic,copy) NSString *courseId;
 @property (nonatomic,copy) NSString *studyDay;
 @property (nonatomic,copy) NSString *studyYear;
 @property (nonatomic,copy) NSString *studyMonth;
 @property (nonatomic,copy) NSString *studyBegin;
 @property (nonatomic,copy) NSString *studyEnd;
 @property (nonatomic,copy) NSString *studyTime;
 */