//
//  KWJDownProgress.h
//  Work01
//
//  Created by kwj on 14/12/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class KWJDownProgress;

//typedef void (^loadDidEnd)(void);
typedef void (^loadOutTime)(void);

@protocol KWJDownProgressDelegete <NSObject>
@optional

@end

@interface KWJDownProgress : UIView

//@property (copy) void (^loadOutTime)(void);
@property (copy) loadOutTime outTime;

+(KWJDownProgress *)progressWithTitle:(NSString *)title;

+(KWJDownProgress *)progressWithTitle:(NSString *)title ParentController:(id)object;

-(void)show;

-(void)stop;

-(void)setProgress:(float)pro;

@end
