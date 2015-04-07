//
//	ReaderContentView.h
//	Reader v2.7.1
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

#import "ReaderThumbView.h"

@class ReaderContentView;
@class ReaderContentPage;
@class ReaderContentThumb;

@protocol ReaderContentViewDelegate <NSObject>

@required // Delegate protocols

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches;

@end

//自定义的ScrollView读取PDF文档信息
@interface ReaderContentView : UIScrollView <UIScrollViewDelegate,UIGestureRecognizerDelegate>

//修改ContntView
@property (nonatomic, strong) ReaderContentPage *theContentView;

@property (nonatomic, strong) UIView *theContainerView;

@property (nonatomic, weak, readwrite) id <ReaderContentViewDelegate> message;

//定义放大的比例 后面发通知改整个的View
@property (nonatomic, assign)CGFloat zoomAmount;

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase;

- (void)showPageThumb:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase guid:(NSString *)guid;

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer;

- (void)zoomIncrement;
- (void)zoomDecrement;
- (void)zoomReset;

@end

#pragma mark -

//
//	ReaderContentThumb class interface
//

@interface ReaderContentThumb : ReaderThumbView

@end
