//
//  KWJSQLite.m
//  Work01
//
//  Created by kwj on 14/12/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJSQLite.h"


@interface KWJSQLite()
{
    sqlite3 *mydb; // db代表着整个数据库，db是数据库实例
}

@property (nonatomic,assign)int OpenDB;

@end

@implementation KWJSQLite

-(id)initWithDBname:(NSString *)name{
    if (self = [super init]) {
        // 0.获得沙盒中的数据库文件名
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];

        // NSLog(@"%@",filename);
        
        // 1.创建(打开)数据库（如果数据库文件不存在，会自动创建）
        _OpenDB = sqlite3_open(filename.UTF8String, &mydb);
        
    }
    return self;
}

-(void)execSQL:(NSString *)sqlstr{
    if (_OpenDB == SQLITE_OK) {
        char *errorMesg = NULL;
        for (int i = 0; i < 3; i++) {
            int result = sqlite3_exec(mydb, sqlstr.UTF8String, NULL, NULL, &errorMesg);
            if (result == SQLITE_OK) {
                NSLog(@"执行成功");
                break;
            }else{
                NSLog(@"执行失败");
                NSLog(@"error:%s",errorMesg);
            }
        }
    } else {
        NSLog(@"打开数据库失败");
    }
}

-(sqlite3_stmt *)select:(NSString *)sqlstr{
    if (_OpenDB == SQLITE_OK) {
        // 2.定义一个stmt存放结果集
        sqlite3_stmt *stmt = NULL;
        
        // 3.检测SQL语句的合法性
        int result = sqlite3_prepare_v2(mydb, sqlstr.UTF8String, -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            // 设置占位符的内容
            // sqlite3_bind_text(stmt, 1, "jack", -1, NULL);
            // 4.执行SQL语句，从结果集中取出数据
            while (sqlite3_step(stmt) == SQLITE_ROW) {
//                可以数据模型处理
                return stmt;
            }
        }else{
            NSLog(@"查询语句是不合法的");
        }
    } else {
        NSLog(@"打开数据库失败");
    }
    return nil;
}

-(void)closeDB{
    sqlite3_close(mydb);
}

-(void)dealloc{
    sqlite3_close(mydb);
}

@end
