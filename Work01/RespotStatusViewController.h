//
//  RespotStatusViewController.h
//  Work01
//
//  Created by kwj on 14/12/12.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJStatus.h"
#import "ViewController.h"

@protocol  RespotStatusViewControllerDelegate<NSObject>
@optional
-(void)dismissSelf;

@end

@interface RespotStatusViewController : UIViewController

@property (nonatomic , strong)KWJStatus *status;

@property (nonatomic , weak)id<RespotStatusViewControllerDelegate> delegates;

@end
