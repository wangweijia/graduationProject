//
//  KWJCourseAlertView.h
//  Work01
//
//  Created by kwj on 14/11/24.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Courseware.h"

@class KWJCourseAlertView;


@protocol  KWJCourseAlertDelegete <NSObject>
@optional
-(void)cellSeleted:(KWJCourseAlertView *)alert couseware:(Courseware *)courseware;
-(void)cellSeleted:(KWJCourseAlertView *)alert couseware:(Courseware *)courseware index:(NSIndexPath *)index;
@end

// Blocks definition for table view management
typedef void (^KWJCourseAlertRowSelectionBlock)(NSIndexPath *selectedIndex);
typedef void (^KWJCourseAlertCompletionBlock)(void);


@interface KWJCourseAlertView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) KWJCourseAlertCompletionBlock completionBlock;	// Called when Cancel button pressed 取消按钮按下时调用
@property (nonatomic, strong) KWJCourseAlertRowSelectionBlock selectionBlock;	// Called when a row in table view is pressed 当一行在表视图 选中时
@property (nonatomic) id<KWJCourseAlertDelegete> delegates;

// Classe method; rowsBlock and cellsBlock MUST NOT be nil
// 取消键的 文字
+(KWJCourseAlertView *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle courseware:(NSArray *)coursewareArray delegate:(id)object;

// Show the alert
-(void)show;

@end