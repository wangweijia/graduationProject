//
//  TablePdfViewController.h
//  ;
//
//  Created by wangkw on 13-11-28.
//  Copyright (c) 2013年 CAC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReaderDocument.h"

#import "ReaderViewController.h"

#import "ReaderContentPage.h"

#import "ReaderContentView.h"

//缩略图事件
#import "ThumbsViewController.h"

@class DocumentReadingViewController;

@class MPAppDelegate;

@class DocumentViewController;

//#import "DemoViewController.h"
#import "PDFReadController.h"

@interface TablePdfViewController : UIViewController<ThumbsViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    //放大缩小的比例数值
    CGFloat contenViewZoomScale;
    
    MPAppDelegate *delegate;
    
    DocumentViewController *docViewCon;
    
}

@property(nonatomic, retain)NSString *pdfLocalPath;
//用来显示Pdf的数据源信息
@property (nonatomic, retain)NSMutableArray *pdfDataArr;

//调整大小后的Rect区域
@property (nonatomic,assign)CGRect pdfShowRect;

//pdf原始大小的区域
@property (nonatomic,assign)CGRect pdfSourceRect;

//前面一次的PdfShowRect;
@property (nonatomic, assign)CGRect lastPdfShowRect;

//文档对象给用户的
@property (nonatomic,retain) ReaderDocument *doucmentObj;

//缩略图视图控制器信息
@property (nonatomic,retain) ThumbsViewController *thumbsViewController;
//pdf的宽度大小
@property (nonatomic,assign) float pdfWidth;
//保留上一次的偏移量
@property (nonatomic, assign)CGPoint tableViewOffSet;

//显示缩略图信息
-(void)thumbViewShow;

//隐藏缩略图信息
-(void)thumbViewHide;
@property (retain, nonatomic) IBOutlet UITableView *mainTableView;


//判断是否显现缩略图View
@property (nonatomic,assign) BOOL isShowThumbView;
@property (retain, nonatomic) IBOutlet UIScrollView *zoomScrollView;


@property(nonatomic, assign)id<hideThumbView> delegate;

@property (nonatomic, assign)BOOL isShowToolBtn;


@end
