//
//  UserFriendsTableViewController.h
//  Work01
//
//  Created by kwj on 14/12/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol userFriendsTableViewControllerDelegate <NSObject>
@optional
-(void)returnSelectedFriends:(NSArray *)array;

@end

@interface UserFriendsTableViewController : UITableViewController

@property (nonatomic,weak) id<userFriendsTableViewControllerDelegate> delegates;

@end
