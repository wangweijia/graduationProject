//
//  StudyInfo.h
//  Work01
//
//  Created by kwj on 15/1/12.
//  Copyright (c) 2015年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface StudyInfo : NSObject

@property (nonatomic,copy) NSString *courseName;
@property (nonatomic,copy) NSString *courseId;
@property (nonatomic,copy) NSString *studyDay;
@property (nonatomic,copy) NSString *studyYear;
@property (nonatomic,copy) NSString *studyMonth;
@property (nonatomic,copy) NSString *studyBegin;
@property (nonatomic,copy) NSString *studyEnd;
@property (nonatomic,copy) NSString *studyTime;

+ (NSMutableArray *)StudyInfoWithStmt:(sqlite3_stmt *)stmt;

@end

/*
 dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
 dic[@"courseName"] = [NSString stringWithFormat:@"'%@'",_xmlName];
 dic[@"courseId"] = [NSString stringWithFormat:@"'%@'",_xmlPath];
 dic[@"studyDay"] = [NSString stringWithFormat:@"'%@'",day];
 dic[@"studyYear"] = [NSString stringWithFormat:@"'%@'",year];
 dic[@"studyMonth"] = [NSString stringWithFormat:@"'%@'",month];
 dic[@"studyBegin"]  = [NSString stringWithFormat:@"'%@'",self.beginTime];
 dic[@"studyEnd"] = [NSString stringWithFormat:@"'%@'",endTime];
 dic[@"studyTime"] = [NSString stringWithFormat:@"'%@'",studyTime];
 */