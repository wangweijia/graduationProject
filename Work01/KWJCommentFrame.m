//
//  KWJCommentFrame.m
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJCommentFrame.h"

//头像
#define ICONW 35

@interface KWJCommentFrame()

/* 名字字体 */
@property(nonatomic,strong) NSDictionary *nameFontDic;
/* 时间的字体 */
@property(nonatomic,strong) NSDictionary *timeFontDic;
/* 正文的字体 */
@property(nonatomic,strong) NSDictionary *contentFontDic;

@end

@implementation KWJCommentFrame

-(void)setComment:(KWJComment *)comment{
    _comment = comment;
    
    /* 名字字体 */
    _nameFontDic = @{NSFontAttributeName:CommentNameFont};
    /* 时间的字体 */
    _timeFontDic = @{NSFontAttributeName:CommentTimeFont};
    /* 正文的字体 */
    _contentFontDic = @{NSFontAttributeName:CommentContentFont};
    
    //iconView
    CGFloat iconX = TableBorder;
    CGFloat iconY = TableBorder;
    CGFloat iconW = ICONW;
    CGFloat iconH = ICONW;
    _iconViewF = CGRectMake(iconX, iconY, iconW, iconH);
    
    //nameView
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + TableBorder;
    CGFloat nameY = iconY;
    CGSize nameSize = [comment.user.name sizeWithAttributes:_nameFontDic];
    _nameViewF = (CGRect){{nameX,nameY},nameSize};
    
    //timeView
    CGFloat timeX = nameX;
    CGFloat timtY = CGRectGetMaxY(_nameViewF) + TableBorder;
    CGSize timeSize = [comment.created_at sizeWithAttributes:_timeFontDic];
    _timeViewF = (CGRect){{timeX,timtY},timeSize};
    
    //textView
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_timeViewF) + TableBorder * 2;
    CGFloat contentMaxW = [UIScreen mainScreen].bounds.size.width - TableBorder - contentY;
    CGSize contentSize = [comment.text boundingRectWithSize:CGSizeMake(contentMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:_contentFontDic context:nil].size;
    _contentViewF = (CGRect){{contentX,contentY},contentSize};
    
    //cell高度
    _cellH = CGRectGetMaxY(_contentViewF) + TableBorder;
    
}

@end
