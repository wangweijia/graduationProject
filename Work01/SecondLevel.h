//
//  SecondLevel.h
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SecondLevel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property (nonatomic) NSMutableArray *word;
@property (nonatomic) NSMutableArray *ppt;
@property (nonatomic) NSMutableArray *video;
@property (nonatomic) NSMutableArray *pdf;

+(instancetype)secondLevelWithArray:(NSArray *)array;

@end
