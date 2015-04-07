//
//  FirstLevel.h
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstLevel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic)NSMutableArray *secondLevel;

//是否 展开选课列表
@property (nonatomic,assign,getter=isOpened) BOOL opened;

+(instancetype)firstLevelWithArray:(NSArray *)array;

@end
