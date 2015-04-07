//
//  KWJHandleSQL.m
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJHandleSQL.h"

@interface KWJHandleSQL()

@property (nonatomic,copy) NSString *dbName;

@property (nonatomic,strong) KWJSQLite *mysql;

@end

@implementation KWJHandleSQL

-(id)initDBName:(NSString *)name{
    if (self = [super init]) {
        _dbName = name;
        KWJSQLite *mysql = [[KWJSQLite alloc] initWithDBname:name];
        _mysql = mysql;
    }
    return self;
}

-(void)creatTabel:(NSString *)name key:(NSDictionary *)dic{
    NSString *col = @"";
    NSArray *key = [dic allKeys];
    for (int i = 0; i < key.count ; i++) {
        NSString *temp = key[i];
        col = [col stringByAppendingString: [NSString stringWithFormat:@",%@ %@",temp,dic[temp]]];
    }
    NSString *sqlstr = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement %@);",name,col];
    [_mysql execSQL:sqlstr];
    NSLog(@"创建表格");
}

-(void)insertInto:(NSString *)name value:(NSDictionary *)value{
    NSArray *key = [value allKeys];
    NSString *k = @"";
    NSString *v = @"";
    for (int i = 0; i < key.count; i++) {
        NSString *temp = key[i];
        k = [k stringByAppendingString:[NSString stringWithFormat:@"%@",temp]];
        v = [v stringByAppendingString:[NSString stringWithFormat:@"%@",value[temp]]];
        if (i + 1 < key.count) {
            k = [k stringByAppendingString:@","];
            v = [v stringByAppendingString:@","];
        }
    }
    NSString *sqlstr = [NSString stringWithFormat:@"insert into %@ (%@) values(%@);",name,k,v];
//    NSLog(@"%@",sqlstr);
    [_mysql execSQL:sqlstr];
    NSLog(@"插入数据");
}

-(void)deletesFrom:(NSString *)name where:(NSDictionary *)where{
    NSArray *key = [where allKeys];
    NSString *w = @"";
    for (int i = 0; i < key.count; i++) {
        NSString *temp = key[i];
        w = [w stringByAppendingString:[NSString stringWithFormat:@"%@ = %@",temp,where[temp]]];
        if (i + 1 < key.count) {
            w = [w stringByAppendingString:@" and "];
        }
    }
    NSString *sqlstr = [NSString stringWithFormat:@"delete from %@ where %@;",name,w];
    [_mysql execSQL:sqlstr];
    NSLog(@"删除数据");
}

-(sqlite3_stmt *)selectTabel:(NSString *)name value:(NSArray *)value where:(NSDictionary *)where{
    NSString *v = @"";
    for (int i = 0; i < value.count; i++) {
        v = [v stringByAppendingString:[NSString stringWithFormat:@"%@",value[i]]];
        if (i + 1 < value.count) {
            v = [v stringByAppendingString:@","];
        }
    }
    NSString *w = @"";
    NSArray *key = [where allKeys];
    for (int i = 0; i < key.count; i++) {
        NSString *temp = key[i];
        w = [w stringByAppendingString:[NSString stringWithFormat:@"%@ = %@",temp,where[temp]]];
        if (i + 1 < key.count) {
            w = [w stringByAppendingString:@" and "];
        }
    }
    NSString *sqlstr = [NSString stringWithFormat:@"select %@ from %@ where %@;",v,name,w];
    sqlite3_stmt *stmt = [self.mysql select:sqlstr];
    if (stmt == NULL) {
        NSLog(@"查询：空数据");
        return nil;
    }else{
        NSLog(@"查询：非空数据");
        return stmt;
    }
}


@end
