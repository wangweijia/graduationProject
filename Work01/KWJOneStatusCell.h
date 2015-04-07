//
//  KWJOneStatusCell.h
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWJStatusFrame;

@interface KWJOneStatusCell : UITableViewCell

//@property (nonatomic,strong) KWJStatus *status;

@property (nonatomic,strong) KWJStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
