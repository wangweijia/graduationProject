//
//  KWJSQLite.h
//  Work01
//
//  Created by kwj on 14/12/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface KWJSQLite : NSObject

-(id)initWithDBname:(NSString *)name;

-(void)execSQL:(NSString *)sqlstr;

-(sqlite3_stmt *)select:(NSString *)sqlstr;

-(void)closeDB;

@end
