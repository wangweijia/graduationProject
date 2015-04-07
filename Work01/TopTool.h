//
//  TopTool.h
//  Work01
//
//  Created by kwj on 14/12/11.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWJStatus;

@protocol topToolDelegate <NSObject>
@optional
-(void)toolBtnClicked:(UIButton *)send;

@end

@interface TopTool : UIImageView

@property (nonatomic, weak) UIButton *selectBtn;

@property (nonatomic,strong) KWJStatus *status;

@property (nonatomic,weak) id<topToolDelegate> delegates;

-(void)selectBtn:(NSInteger)tag;

@end
