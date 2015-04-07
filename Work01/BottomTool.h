//
//  BottomTool.h
//  Work01
//
//  Created by kwj on 14/12/11.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bottomBoolDelegate <NSObject>
@optional
-(void)bottomBoolClicked:(UIButton *)sender;

@end

@interface BottomTool : UIImageView

@property (nonatomic,weak) id<bottomBoolDelegate> delegates;

-(void)setBtnTitle:(NSString *)title;

@end
