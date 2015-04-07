//
//  RespotFrame.m
//  Work01
//
//  Created by kwj on 14/12/13.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "RespotFrame.h"

//@property (nonatomic, assign, readonly) CGRect resoptF;
//@property (nonatomic, assign, readonly) CGRect textViewF;
//@property (nonatomic, assign, readonly) CGRect photoViewF;
//@property (nonatomic, assign, readonly) CGRect statusViewF;
//@property (nonatomic, assign, readonly) CGRect nameLabelF;
//@property (nonatomic, assign, readonly) CGRect statusLabelF;

@implementation RespotFrame

-(void)setStatus:(KWJStatus *)status{
    _status = status;
    
    CGFloat respotX = 0;
    CGFloat respotY = 64;
    CGFloat respotW = _selfW;
    
    CGFloat textX = TableBorder;
    CGFloat textY = TableBorder;
    CGFloat textW = respotW - 2 * TableBorder;
    CGFloat textH = 70;
    _textViewF = CGRectMake(textX, textY, textW, textH);
    
    CGFloat photoX = textX;
    CGFloat photoY = CGRectGetMaxY(_textViewF) + TableBorder;
    CGFloat photoW = 50;
    CGFloat photoH = 50;
    _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
    
    CGFloat statusX = CGRectGetMaxX(_photoViewF);
    CGFloat statusY = photoY;
    CGFloat statusW = respotW - TableBorder - statusX;
    CGFloat statusH = photoH;
    _statusViewF = CGRectMake(statusX, statusY, statusW, statusH);
    
    CGFloat nameLabelX =  TableBorder;
    CGFloat nameLabelY =  2;
    CGFloat nameLabelW = statusW - 2 * TableBorder;
    CGFloat nameLabelH = 15;
    _nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat statusLabelX = nameLabelX;
    CGFloat statusLabelY = CGRectGetMaxY(_nameLabelF);
    CGFloat statusLabelW = statusW - 2 * TableBorder;
    CGFloat ststusLabelH = 35;
    _statusLabelF = CGRectMake(statusLabelX, statusLabelY, statusLabelW, ststusLabelH);

    
    CGFloat respotH = CGRectGetMaxY(_statusViewF) + TableBorder;
    _respotF = CGRectMake(respotX, respotY, respotW, respotH);
    
}

@end
