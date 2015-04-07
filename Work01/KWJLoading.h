//
//  KWJLaoding.h
//  Work01
//
//  Created by kwj on 14/11/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class KWJLoading;

//typedef void (^loadDidEnd)(void);
typedef void (^loadOutTime)(void);

@protocol KWJLoadingDelegete <NSObject>
@optional

@end

@interface KWJLoading : UIView

//@property (copy) void (^loadOutTime)(void);
@property (copy) loadOutTime outTime;

+(KWJLoading *)loadingWithTitle:(NSString *)title;

+(KWJLoading *)loadingWithTitle:(NSString *)title ParentController:(id)object;

-(void)show;

-(void)stop;

@end
