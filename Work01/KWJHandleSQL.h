//
//  KWJHandleSQL.h
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWJSQLite.h"

@interface KWJHandleSQL : NSObject

-(id)initDBName:(NSString *)name;

-(void)creatTabel:(NSString *)name key:(NSDictionary *)dic;

-(void)insertInto:(NSString *)name value:(NSDictionary *)value;

-(void)deletesFrom:(NSString *)name where:(NSDictionary *)where;

-(sqlite3_stmt *)selectTabel:(NSString *)name value:(NSArray *)value where:(NSDictionary *)where;

@end
