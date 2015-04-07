//
//  KWJPusblishPhotoView.m
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJPusblishPhotoView.h"
#import "HeaderFile.h"

#define imageWH 75
#define boder 15

@interface KWJPusblishPhotoView()

@property (nonatomic)NSMutableArray *imageViewArray;

@property (nonatomic,assign)int photoNum;

@property (nonatomic,assign)int rowMax;

//@property (nonatomic,assign) CGFloat viewH;

@end

@implementation KWJPusblishPhotoView

-(id)initWithMax:(int)photoNum rowMax:(int)rowMax{
    if (self = [super init]) {
        //存放照片的数组
        _photoArray = [NSMutableArray array];
        //存放imageview的数组
        _imageViewArray = [NSMutableArray array];
        
        self.userInteractionEnabled = YES;
        
        self.photoNum = photoNum;
        self.rowMax = rowMax;
    }
    return self;
}

-(id)init{
    if (self = [super init]) {
        //存放照片的数组
        _photoArray = [NSMutableArray array];
        //存放imageview的数组
        _imageViewArray = [NSMutableArray array];
        
        self.photoNum = 6;
        self.rowMax = 3;
    }
    return self;
}

//添加图片到 照片数组
-(void)addPhoto:(UIImage *)image{
    if (_photoArray.count < _photoNum) {
        [_photoArray addObject:image];
        [self addImageView];
        [self imageFrame];
    }
}

//添加 imageview
-(void)addImageView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [_imageViewArray addObject:imageView];//添加 uiimageview 到数组
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.0;
    imageView.image = [_photoArray lastObject];
    imageView.tag = 10000 + (int)_imageViewArray.count;
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(2, 2, 20, 20);
    delete.backgroundColor = KWJColor(244, 244, 244);
//    delete.backgroundColor = [KWJColor(244, 244, 244) colorWithAlphaComponent:0.1];
    delete.layer.cornerRadius = 10.0;
    delete.tag = imageView.tag;
    [delete addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [delete setImage:[UIImage imageNamed:@"delete-circular"] forState:UIControlStateNormal];
    [imageView addSubview:delete];
    
    [self addSubview:imageView];
}

-(void)deleteBtnClick:(UIButton *)sender{
    int btnTage = (int)sender.tag - 10001;//(从0开始)
    [_photoArray removeObject:_photoArray[btnTage]];
//    NSLog(@"%d",btnTage);
    
    for (int i = btnTage; i < _imageViewArray.count; i++) {
        if (i == _imageViewArray.count - 1) {
            UIImageView *temp = [_imageViewArray lastObject];
            [_imageViewArray removeObject:temp];
            [temp removeFromSuperview];//销毁
            //[btn removeFromSuperview];
            [self imageFrame];
        }else{
            ((UIImageView *)_imageViewArray[i]).image = ((UIImageView *)_imageViewArray[i + 1]).image;
        }
    }
}

-(void)imageFrame{
    
    for (int i = 0; i < _imageViewArray.count; i++) {
        int low = i / _rowMax;
        int row = i % _rowMax;
        
        CGFloat imageX = (1 + row) * boder + row * imageWH;
        CGFloat imageY = low * (boder + imageWH);
        CGFloat imageW = imageWH;
        CGFloat imageH = imageWH;
        ((UIImageView *)_imageViewArray[i]).frame = CGRectMake(imageX, imageY, imageW, imageH);
        
    }
    CGFloat fH = CGRectGetMaxY(((UIImageView *)[_imageViewArray lastObject]).frame);
    
    CGFloat fX = self.frame.origin.x;
    CGFloat fY = self.frame.origin.y;
    CGFloat fW = self.frame.size.width;
    
    
    self.frame = CGRectMake(fX, fY, fW, fH);
}
@end
