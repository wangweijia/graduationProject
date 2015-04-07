//
//  KWJStatusToolBar.h
//  Work01
//
//  Created by kwj on 14/12/5.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWJStatus;

@protocol KWJStatusToolBarDelegate <NSObject>
@optional
-(void)toolBarBtnClick:(UIButton *)sender status:(KWJStatus *)status;

@end

@interface KWJStatusToolBar : UIImageView

@property (nonatomic,strong) KWJStatus *status;

@property (nonatomic,weak) id<KWJStatusToolBarDelegate> delegates;

@end
