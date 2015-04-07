//
//  MyCourseware.h
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MyCourseware : NSObject

@property (nonatomic,assign)int coursewareId;
@property (nonatomic,copy)NSString *coursewareTitle;
@property (nonatomic,copy)NSString *coursewareName;
@property (nonatomic,copy)NSString *coursewareType;
@property (nonatomic,copy)NSString *access_token;
@property (nonatomic,copy)NSString *courseId;
@property (nonatomic,copy)NSString *filePath;

+ (NSMutableArray *)CoursewareWithStmt:(sqlite3_stmt *)stmt;

@end
/*
 dic[@"coursewareTitle"]
 dic[@"coursewareName"]
 dic[@"coursewareType"]
 dic[@"access_token"]
 dic[@"courseId"]
 dic[@"filePath"]
 */