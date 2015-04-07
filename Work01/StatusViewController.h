//
//  StatusViewController.h
//  Work01
//
//  Created by kwj on 14/12/8.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJStatus.h"
#import "KWJStatusFrame.h"
#import "Loading.h"
#import "KWJStatusHeaderView.h"

@interface StatusViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoadBDConnectionDataDelegate,topToolDelegate,bottomBoolDelegate>

@property (nonatomic,strong) KWJStatus *status;

@property (nonatomic,strong) KWJStatusFrame *statusFrame;

@end
