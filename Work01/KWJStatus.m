//
//  KWJStatus.m
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatus.h"
#import "KWJStatusUser.h"
#import "NSDate+KWJ.h"
#import "KWJPhoto.h"

@implementation KWJStatus

+ (instancetype)statusWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
//        NSLog(@"%@",dic);
        self.text = dic[@"text"];
        self.source = dic[@"source"];
        self.idstr = dic[@"idstr"];
        self.created_at = dic[@"created_at"];
        self.reposts_count = [dic[@"reposts_count"] intValue];
        self.comments_count = [dic[@"comments_count"] intValue];
        self.attitudes_count = [dic[@"attitudes_count"] intValue];
        self.user = [KWJStatusUser userWithDic:dic[@"user"]];
//        self.annotations = dic[@"annotations"];// 应该为字典形式
        if (dic[@"annotations"] != nil) {
            NSArray *temp = dic[@"annotations"];
            NSDictionary *tempDic = temp[0];
            self.xmlPath = tempDic[@"path"];
            self.xmlName = tempDic[@"name"];
        }
        
        self.thumbnail_pic = dic[@"thumbnail_pic"];
        if (((NSArray *)dic[@"pic_urls"]).count > 0) {
            //发送的图片数组
            NSArray *picArray = (NSArray *)dic[@"pic_urls"];
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < picArray.count; i++) {
                NSDictionary *picDic = (NSDictionary *)picArray[i];
                [array addObject:[KWJPhoto photoWithDic:picDic]];
            }
            self.pic_urls = array;
        }
        
        if (dic[@"retweeted_status"]) {
            self.retweeted_status = [KWJStatus statusWithDic:dic[@"retweeted_status"]];
        }
    }
    return self;
}


//返回创建时间时  对时间进行加工
- (NSString *)created_at
{
    NSString *format = @"EEE MMM dd HH:mm:ss Z yyyy";
    return [NSDate dateWith:_created_at dateFormat:format];
}

//在插入 输入时 对来源 加工
- (void)setSource:(NSString *)source
{
    if (source.length > 0) {
        int loc = (int)[source rangeOfString:@">"].location + 1;
        int length = (int)[source rangeOfString:@"</"].location - loc;
        source = [source substringWithRange:NSMakeRange(loc, length)];
    }
    _source = [NSString stringWithFormat:@"来自%@", source];
}

@end
