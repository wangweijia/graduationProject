//
//  KWJPhotosView.m
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJPhotosView.h"
#import "KWJPhoto.h"
#import "KWJPhotoView.h"

//第三方控件
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define KWJPhotoW 70
#define KWJPhotoH 70
#define KWJPhotoMargin 10

@implementation KWJPhotosView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        for (int i = 0; i < 9; i++) {
            KWJPhotoView *photoView = [[KWJPhotoView alloc]init];
            photoView.tag = i;
            
            //添加点击事件
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:photoView];
        }
    }
    return self;
}

- (void)photoTap:(UITapGestureRecognizer *)recognizer{
    int count = (int)self.photos.count;
    
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.srcImageView = self.subviews[i];
        
        KWJPhoto *kwjphoto = self.photos[i];
        NSString *photoUrl = [kwjphoto.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        
        mjphoto.url = [NSURL URLWithString:photoUrl];
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = recognizer.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}

-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    for (int i = 0; i<self.subviews.count; i++) {
        // 取出i位置对应的imageView
        KWJPhotoView *photoView = self.subviews[i];
        
        // 判断这个imageView是否需要显示数据
        if (i < photos.count) {
            // 显示图片
            photoView.hidden = NO;
            
            // 传递模型数据
            photoView.photo = photos[i];
            
            // 设置子控件的frame
            int maxColumns = (photos.count == 4) ? 2 : 3;
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat photoX = col * (KWJPhotoW + KWJPhotoMargin);
            CGFloat photoY = row * (KWJPhotoH + KWJPhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, KWJPhotoW, KWJPhotoH);
            
            // Aspect : 按照图片的原来宽高比进行缩
            // UIViewContentModeScaleAspectFit : 按照图片的原来宽高比进行缩放(一定要看到整张图片)
            // UIViewContentModeScaleAspectFill :  按照图片的原来宽高比进行缩放(只能图片最中间的内容)
            // UIViewContentModeScaleToFill : 直接拉伸图片至填充整个imageView
            
            if (photos.count == 1) {
                photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
        } else { // 隐藏imageView
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)photosViewSizeWithPhotosCount:(int)count{
    
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * KWJPhotoH + (rows - 1) * KWJPhotoMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * KWJPhotoW + (cols - 1) * KWJPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
