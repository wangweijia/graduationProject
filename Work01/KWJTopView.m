//
//  KWJTopView.m
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJTopView.h"
#import "UIImage+KWJ.h"
#import "UIImageView+WebCache.h"
#import "KWJStatus.h"
#import "KWJStatusUser.h"
#import "KWJStatusFrame.h"
#import "KWJPhotosView.h"

//公用头文件
#import "HeaderFile.h"

@interface KWJTopView()

/* 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/* 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/* 配图 */
@property (nonatomic, weak) KWJPhotosView *photoView;
/* 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/* 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/* 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/* 正文\内容 */
@property (nonatomic, weak) UILabel *contentLabel;

/* 被转发微博的view(父控件) */
@property (nonatomic, weak) UIImageView *retweetView;
/* 被转发微博作者的昵称 */
@property (nonatomic, weak) UILabel *retweetNameLabel;
/* 被转发微博的正文\内容 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/* 被转发微博的配图 */
@property (nonatomic, weak) KWJPhotosView *retweetPhotoView;
@end

@implementation KWJTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;//允许用户操作
        /* 1.顶部的view */
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        [self setupOriginalSubviews];
        [self setupRetweetSubviews];
    }
    return self;
}

-(void)setupOriginalSubviews{
    
    /* 2.头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    /* 3.会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [self addSubview:vipView];
    self.vipView = vipView;
    
    /* 4.配图 */
    KWJPhotosView *photoView = [[KWJPhotosView alloc] init];
    [self addSubview:photoView];
    self.photoView = photoView;
    
    /* 5.昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = statusNameFont;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /* 6.时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = statusTimeFont;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /* 7.来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = statusSourceFont;
    [self addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /* 8.正文\内容 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = statusContentFont;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

-(void)setupRetweetSubviews{
    /* 1.被转发微博的view(父控件) */
    UIImageView *retweetView = [[UIImageView alloc] init];
    retweetView.userInteractionEnabled = YES;
    retweetView.image = [UIImage resizedImageWithName:@"timeline_retweet_background" left:0.9 top:0.5];
    [self addSubview:retweetView];
    self.retweetView = retweetView;
    
    /* 2.被转发微博作者的昵称 */
    UILabel *retweetNameLabel = [[UILabel alloc] init];
    retweetNameLabel.font = statusNameFont;
    [self.retweetView addSubview:retweetNameLabel];
    self.retweetNameLabel = retweetNameLabel;
    
    /* 3.被转发微博的正文\内容 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = statusContentFont;
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /* 4.被转发微博的配图 */
    KWJPhotosView *retweetPhotoView = [[KWJPhotosView alloc] init];
    [self.retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
}

/*
 *  控件 frame加载
 */
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self setupOriginalData];
    [self setupRetweetData];
}

/*
 *  原创微博
 */
- (void)setupOriginalData
{
    KWJStatus *status = self.statusFrame.status;
    KWJStatusUser *user = status.user;
    
    // 2.头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    self.iconView.frame = self.statusFrame.iconViewF;
    
    // 3.昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    // 4.vip
    if (user.mbrank > 0) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageWithName:[NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank]];
        self.vipView.frame = self.statusFrame.vipViewF;
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        
        self.vipView.hidden = YES;
    }
    
    // 5.时间
    self.timeLabel.text = status.created_at;
    [self.timeLabel setTextColor:[UIColor orangeColor]];
    self.timeLabel.frame = self.statusFrame.timeLabelF;
    
    // 6.来源
    self.sourceLabel.text = status.source;
    [self.sourceLabel setTextColor:[UIColor grayColor]];
    self.sourceLabel.frame = self.statusFrame.sourceLabelF;
    
    // 7.正文
    self.contentLabel.text = status.text;
    self.contentLabel.frame = self.statusFrame.contentLabelF;
    //    self.contentLabel.backgroundColor = [UIColor blueColor];
    
    // 8.配图
    if (status.pic_urls) {
        self.photoView.hidden = NO;
        self.photoView.frame = self.statusFrame.photoViewF;
//        [self.photoView sd_setImageWithURL:[NSURL URLWithString:status.pic_urls] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
        self.photoView.photos = status.pic_urls;
    } else {
        self.photoView.hidden = YES;
    }
}

/*
 *  被转发微博
 */
- (void)setupRetweetData
{
    KWJStatus *retweetStatus = self.statusFrame.status.retweeted_status;
    KWJStatusUser *user = retweetStatus.user;
    
    //是否有 转发控件
    if (retweetStatus) {
        self.retweetView.hidden = NO;
        self.retweetView.frame = self.statusFrame.retweetViewF;
        
        //昵称
        self.retweetNameLabel.text = user.name;
        self.retweetNameLabel.textColor = KWJColor(67, 107, 163);
        self.retweetNameLabel.frame = self.statusFrame.retweetNameLabelF;
        
        //正文
        self.retweetContentLabel.text = retweetStatus.text;
        self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
        
        if (retweetStatus.pic_urls) {
            self.retweetPhotoView.hidden = NO;
            self.retweetPhotoView.frame = self.statusFrame.retweetPhotoViewF;
//            [self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:retweetStatus.pic_urls[0]] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
            self.retweetPhotoView.photos = retweetStatus.pic_urls;
        }else{
            self.retweetPhotoView.hidden = YES;
        }
    }else{
        self.retweetView.hidden = YES;
    }
}

@end
