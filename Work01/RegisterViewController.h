//
//  RegisterViewController.h
//  Work01
//
//  Created by kwj on 14/11/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loading.h"

@protocol registerViewDelegate <NSObject>
@optional
-(void)gotLoginUserId:(NSString *)userId pwd:(NSString *)pwd;

@end

@interface RegisterViewController : UIViewController<LoadBDConnectionDataDelegate>

@property (nonatomic,weak) id<registerViewDelegate> delegates;

@end
