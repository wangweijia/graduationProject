//
//  KWJLableButton.h
//  Work01
//
//  Created by kwj on 14/11/24.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Courseware.h"

@class KWJLableButton;

@protocol KWJLableButtonDelegate <NSObject>
@optional
-(void)labelButtonClick:(KWJLableButton *)button;

@end

@interface KWJLableButton : UIButton

@property (nonatomic,weak) id<KWJLableButtonDelegate> delegates;

@property (nonatomic) NSArray *coursewareArray;

@property (nonatomic) NSString *title;

+(instancetype)labelButtonWithImage:(NSString *)image;

-(void)setNumber:(NSString *)number Title:(NSString *)title CoursewareArray:(NSArray *)array;

@end
