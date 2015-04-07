//
//  KWJResopt.h
//  Work01
//
//  Created by kwj on 14/12/13.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJStatus.h"
#import "RespotFrame.h"

@interface KWJRespot : UIView

@property (nonatomic,strong) RespotFrame *respotFrame;

@property (nonatomic,strong) KWJStatus *status;

//转发 附带 文字
@property (nonatomic,weak)UITextView *respotText;

@end
