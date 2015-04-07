//
//  KWJStatusTextView.h
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^notEmpty)(NSString *text);

@interface KWJStatusTextView : UIView

@property (nonatomic,strong)notEmpty notempty;

-(id)initWithRespot:(NSString *)respot maxWord:(int)num;

-(NSString *)getText;

-(void)setText:(NSString *)text;
@end
