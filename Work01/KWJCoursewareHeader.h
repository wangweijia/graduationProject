//
//  KWJCoursewareHeader.h
//  Work01
//
//  Created by kwj on 14/12/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KWJCoursewareHeaderDelegate <NSObject>
@optional
-(void)headerBtnClick:(UIButton *)sender;

@end

@interface KWJCoursewareHeader : UITableViewHeaderFooterView

@property (nonatomic,weak)id<KWJCoursewareHeaderDelegate> delegates;

@property (nonatomic,strong)UIButton *selectedBtn;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

-(void)setSelectedBtnWithTag:(int)tag;

@end
