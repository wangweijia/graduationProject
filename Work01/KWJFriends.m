//
//  KWJFriends.m
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJFriends.h"

@implementation KWJFriends

+ (instancetype)friendsWithDict:(NSDictionary *)dict{
    KWJFriends *friend = [[KWJFriends alloc]initWithDict:dict];
    return friend;
}

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.idstr = dict[@"idstr"];
        self.screen_name = dict[@"screen_name"];
        self.name = dict[@"name"];
        self.profile_image_url = dict[@"profile_image_url"];
        self.verified = dict[@"verified"];
        self.online_status = [dict[@"online_status"] intValue];
        
        if (dict[@"remark"]) {
            self.remark = dict[@"remark"];
        }
        
        self.isSelected = false;
    }
    return self;
}

@end
/*
 @property (nonatomic,copy) NSString *idstr;
 
 @property (nonatomic,copy) NSString *screen_name;
 
 @property (nonatomic,copy) NSString *name;
 
 @property (nonatomic,copy) NSString *profile_image_url;
 
 @property (nonatomic,assign) BOOL verified;
 
 @property (nonatomic,copy) NSString *remark;
 
 @property (nonatomic,assign) int online_status;
 */
