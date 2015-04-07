//
//  KWJPublishToolView.h
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^allBtnClick)(UIButton *btn);

@interface KWJPublishToolView : UIView

@property (nonatomic,strong)allBtnClick allbtnclick;

-(id)initWith:(allBtnClick)allButtonClick;

-(id)initWith:(allBtnClick)allButtonClick button:(NSArray *)btn;

@end
