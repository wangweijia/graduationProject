//
//  KWJPhotosView.h
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWJPhotosView : UIImageView

/*需要展示的图片(数组里面装的都是IWPhoto模型)*/
@property (nonatomic, strong) NSArray *photos;

/*根据图片的个数返回相册的最终尺寸*/
+ (CGSize)photosViewSizeWithPhotosCount:(int)count;
@end
