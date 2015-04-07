//
//  SectionCell.h
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWJLableButton.h"
@class SecondLevel;

@interface SectionCell : UITableViewCell

@property (nonatomic) SecondLevel *secondLevel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setSecondLevel:(SecondLevel *)secondLevel buttonDeleget:(id)object;

@end
