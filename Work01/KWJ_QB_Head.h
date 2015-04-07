//
//  KWJ_QB_Head.h
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isIOS7	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define isIOS8	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

@interface KWJ_QB_Head : NSObject

@end
