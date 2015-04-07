//
//  KWJPhoto.h
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWJPhoto : NSObject
/*
 *  缩略图
 */
@property (nonatomic, copy) NSString *thumbnail_pic;

+ (instancetype)photoWithDic:(NSDictionary *)dic;
@end
