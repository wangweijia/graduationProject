//
//  KWJPhotoView.m
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJPhotoView.h"
#import "KWJPhoto.h"
#import "UIImage+KWJ.h"
#import "UIImageView+WebCache.h"

@interface KWJPhotoView()

@property (nonatomic,weak) UIImageView *gifView;

@end

@implementation KWJPhotoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIImageView *gifView = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"timeline_image_gif"]];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

-(void)setPhoto:(KWJPhoto *)photo{
    _photo = photo;
    
    // 控制gifView的可见性
    self.gifView.hidden = ![photo.thumbnail_pic hasSuffix:@"gif"];
    
    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}
@end
