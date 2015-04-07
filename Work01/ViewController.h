//
//  ViewController.h
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJStatusCell.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,KWJStatusToolBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *mainNavigation;

@end

