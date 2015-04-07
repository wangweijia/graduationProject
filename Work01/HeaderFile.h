//
//  HeaderFile.h
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

//三原色
#define KWJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//判断设备型号
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface HeaderFile : NSObject

@end
