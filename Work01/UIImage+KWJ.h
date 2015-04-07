//
//  UIImage+KWJ.h
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KWJ)
+ (UIImage *)imageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
