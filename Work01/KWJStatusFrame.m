//
//  KWJStatusFrame.m
//  Work01
//
//  Created by kwj on 14/12/4.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusFrame.h"
#import "KWJStatusUser.h"
#import "KWJStatus.h"
#import "KWJPhotosView.h"

@interface KWJStatusFrame()
//字体
/* 名字字体 */
@property(nonatomic,strong) NSDictionary *nameFontDic;
/* 时间的字体 */
@property(nonatomic,strong) NSDictionary *timeFontDic;
/* 来源的字体 */
@property(nonatomic,strong) NSDictionary *sourceFontDic;
/* 正文的字体 */
@property(nonatomic,strong) NSDictionary *contentFontDic;
@end

@implementation KWJStatusFrame

//-(CGRect)timeLabelF{
//    
//    return self.timeLabelF;
//}

/*
 *  获得微博模型数据之后，计算所有子控件的frame
 */
-(void)setStatus:(KWJStatus *)status{
    _status = status;
    
    //字体
    /* 名字字体 */
    _nameFontDic = @{NSFontAttributeName:statusNameFont};
    /* 时间的字体 */
    _timeFontDic = @{NSFontAttributeName:statusTimeFont};
    /* 来源的字体 */
    _sourceFontDic = @{NSFontAttributeName:statusSourceFont};
    /* 正文的字体 */
    _contentFontDic = @{NSFontAttributeName:statusContentFont};
    
    //cell 的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - 2 * statusTableBorder;
    
    //top view
    CGFloat topViewW = cellW;
    CGFloat topViewH = 0;
    CGFloat topviewX = 0;
    CGFloat topViewY = 0;
    
    //头部
    CGFloat iconViewWH = 35;
    CGFloat iconViewX = statusCellBorder;
    CGFloat iconViewY = statusCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    //昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + statusCellBorder;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [status.user.name sizeWithAttributes:_nameFontDic];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};

    //会员图标
    if (status.user.mbrank > 0) {
        CGFloat vipViewW = 14;
        CGFloat vipViewH = nameLabelSize.height;
        CGFloat vipViewX = CGRectGetMaxX(_nameLabelF) + statusCellBorder;
        CGFloat vipViewY = nameLabelY;
        _vipViewF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
    }
    
    //时间
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + statusCellBorder * 0.5;
    CGSize timeLabelSize = [status.created_at sizeWithAttributes:_timeFontDic];
    _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    //来源
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelF) + statusCellBorder;
    CGFloat soutceLabelY = timeLabelY;
    CGSize sourceLabelSize = [status.source sizeWithAttributes:_sourceFontDic];
    _sourceLabelF = (CGRect){{sourceLabelX,soutceLabelY},sourceLabelSize};
    
    //正文内容
    CGFloat contentLabelX = iconViewX;
    CGFloat contentLabelY = MAX(CGRectGetMaxY(_timeLabelF), CGRectGetMaxY(_iconViewF)) + statusCellBorder;
    CGFloat contentLabelMaxW = topViewW - 2 * statusCellBorder;
    CGSize contentLabelSize = [status.text boundingRectWithSize:CGSizeMake(contentLabelMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:_contentFontDic context:nil].size;
    _contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    //转发微博
    if (status.retweeted_status) {
        CGFloat retweetViewW = contentLabelMaxW;
        CGFloat retweetViewX = contentLabelX;
        CGFloat retweetViewY = CGRectGetMaxY(_contentLabelF) + statusCellBorder;
        CGFloat retweetViewH = 0;
        
        //转发者的 名字
        CGFloat retweetNameLabelX = statusCellBorder;
        CGFloat retweetNameLabelY = statusCellBorder;
        CGSize retweetNameLabelSize = [status.retweeted_status.user.name sizeWithAttributes:_nameFontDic];
        _retweetNameLabelF = (CGRect){{retweetNameLabelX,retweetNameLabelY},retweetNameLabelSize};
        
        //转发者 的正文
        CGFloat retweetContentLabelX = retweetNameLabelX;
        CGFloat retweetContentLabelY = CGRectGetMaxY(_retweetNameLabelF) + statusCellBorder;
        CGFloat retweetContentLabelMaxW = retweetViewW - 2 * statusCellBorder;
        CGSize retweetContentLabelSize = [status.retweeted_status.text boundingRectWithSize:CGSizeMake(retweetContentLabelMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:_contentFontDic context:nil].size;
        _retweetContentLabelF = (CGRect){{retweetContentLabelX,retweetContentLabelY},retweetContentLabelSize};
        
        //被转发者的 配图
        if (((NSArray *)status.retweeted_status.pic_urls).count > 0) {
//            CGFloat retweetPhotoViewWH = 70;
//            CGFloat retweetPhotoViewX = retweetContentLabelX;
//            CGFloat retweetPhotoViewY = CGRectGetMaxY(_retweetContentLabelF) + statusCellBorder;
//            _retweetPhotoViewF = CGRectMake(retweetPhotoViewX, retweetPhotoViewY, retweetPhotoViewWH, retweetPhotoViewWH);
            CGSize photoViewSize = [KWJPhotosView photosViewSizeWithPhotosCount:(int)status.retweeted_status.pic_urls.count];
            CGFloat retweetPhotoViewX = retweetContentLabelX;
            CGFloat retweetPhotoViewY = CGRectGetMaxY(_retweetContentLabelF) + statusCellBorder;
            _retweetPhotoViewF = (CGRect){{retweetPhotoViewX,retweetPhotoViewY},photoViewSize};
            
            retweetViewH = CGRectGetMaxY(_retweetPhotoViewF);
        }else{
            retweetViewH = CGRectGetMaxY(_retweetContentLabelF);
        }
        retweetViewH += statusCellBorder;
        _retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        
        topViewH = CGRectGetMaxY(_retweetViewF);
    }else{
        //没有转发
        //只有在没有转发时 才能发图片
        if (((NSArray *)status.pic_urls).count > 0) {
            //有图片
//            CGFloat photoViewWH = 70;
//            CGFloat photoViewX = contentLabelX;
//            CGFloat photoViewY = CGRectGetMaxY(_contentLabelF) + statusCellBorder;
//            _photoViewF = CGRectMake(photoViewX, photoViewY, photoViewWH, photoViewWH);
            CGSize photoViewSize = [KWJPhotosView photosViewSizeWithPhotosCount:(int)status.pic_urls.count];
            CGFloat photoViewX = contentLabelX;
            CGFloat photoViewY = CGRectGetMaxY(_contentLabelF) + statusCellBorder;
            _photoViewF = (CGRect){{photoViewX,photoViewY},photoViewSize};
            
            topViewH = CGRectGetMaxY(_photoViewF);
        }else{
            topViewH = CGRectGetMaxY(_contentLabelF);
        }
    }
    
    //计算topviewF
    topViewH += statusCellBorder;
    _topViewF = CGRectMake(topviewX, topViewY, topViewW, topViewH);
    _cellHeight_topView = topViewH;
    
    //工具条的高度
    CGFloat statusToolBarX = topviewX;
    CGFloat statusToolBarY = CGRectGetMaxY(_topViewF);
    CGFloat statusToolBarH = 36;
    CGFloat StatusToolBarW = topViewW;
    _statusToolbarF = CGRectMake(statusToolBarX, statusToolBarY, StatusToolBarW, statusToolBarH);
    
    //cell 的高度
    _cellHeight = CGRectGetMaxY(_statusToolbarF) + statusTableBorder + 10;
}

-(CGRect)timeLabelF{
//    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelX = CGRectGetMinX(_nameLabelF);
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + statusCellBorder * 0.5;
    CGSize timeLabelSize = [_status.created_at sizeWithAttributes:_timeFontDic];
    _timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    //来源
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelF) + statusCellBorder;
    CGFloat soutceLabelY = timeLabelY;
    CGSize sourceLabelSize = [_status.source sizeWithAttributes:_sourceFontDic];
    _sourceLabelF = (CGRect){{sourceLabelX,soutceLabelY},sourceLabelSize};
    
    return _timeLabelF;
}

@end
