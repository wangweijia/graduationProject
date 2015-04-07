//
//  KWJFriendCell.h
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWJFriends;

@interface KWJFriendCell : UITableViewCell

@property (nonatomic,strong) KWJFriends *friends;

//@property (nonatomic)BOOL isSelect;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)cellIsSelected:(BOOL)select;

@end
