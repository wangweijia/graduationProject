//
//  KWJPusblishPhotoView.h
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWJPusblishPhotoView : UIView

@property (nonatomic) NSMutableArray *photoArray;

-(void)addPhoto:(UIImage *)image;

-(id)initWithMax:(int)photoNum rowMax:(int)rowMax;

@end
