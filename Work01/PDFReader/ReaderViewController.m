//
//	ReaderViewController.m
//	Reader v2.7.2
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

#import "ReaderConstants.h"
#import "ReaderViewController.h"
#import "ThumbsViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ReaderContentView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"

#import "ReaderContentPage.h"

#import <MessageUI/MessageUI.h>

@interface ReaderViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate,
									ReaderMainToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate, ThumbsViewControllerDelegate>
@end

@implementation ReaderViewController
{
	ReaderDocument *document;

	UIScrollView *theScrollView;

	ReaderMainToolbar *mainToolbar;

	ReaderMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;
    
    //添加重用的数组对象
    NSMutableArray *contentMutArr;
    
    //scrollView 最上面View的位置 这个值初始是0 后面有变化的
    int firstViewIndex;

	UIPrintInteractionController *printInteraction;

	NSInteger currentPage;

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL isVisible;
}

#pragma mark Constants

#define PAGING_VIEWS 5  //可以修改的图片的预加载View信息的

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 48.0f

#define TAP_AREA_SIZE 48.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark Support methods

- (void)updateScrollViewContentSize
{
	NSInteger count = [document.pageCount integerValue];

	if (count > PAGING_VIEWS)
        
        count = PAGING_VIEWS; // Limit
    
    CGRect viewRect = CGRectZero;
    
    viewRect.size = theScrollView.bounds.size; //这个给定的值是718 700的尺寸
    
    ReaderContentPage  *tempContentView = [[ReaderContentPage alloc] initWithURL:document.fileURL page:1 password:document.password];
    
    viewRect.size=CGSizeMake(viewRect.size.width, (int)(viewRect.size.width*tempContentView.frame.size.height/tempContentView.frame.size.width));
    
    self.pdfShowRect=viewRect;
    
    CGFloat contentHeight = theScrollView.bounds.size.height*count;
    
    if (self.pdfShowRect.size.height>0) {
        contentHeight = self.pdfShowRect.size.height*count;
    }
	CGFloat contentWidth = theScrollView.bounds.size.width;

    //718 700 前面界面的ContentSize
	theScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateScrollViewContentViews
{
	[self updateScrollViewContentSize]; // Update the content size

	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set

	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
		^(id key, id object, BOOL *stop)
		{
			ReaderContentView *contentView = object;
            [pageSet addIndex:contentView.tag];
		}
	];

	__block CGRect viewRect = CGRectZero;
    
    viewRect.size = theScrollView.bounds.size;
    
    if (self.pdfShowRect.size.height>0) {
        viewRect.size=self.pdfShowRect.size;
    }

	__block CGPoint contentOffset = CGPointZero;
    
    NSInteger page = [document.pageNumber integerValue];

	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
		^(NSUInteger number, BOOL *stop)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key

			ReaderContentView *contentView = [contentViews objectForKey:key];

			contentView.frame = viewRect;
            
            if (page == number) contentOffset = viewRect.origin;

			viewRect.origin.y += viewRect.size.height; // Next view frame position
		}
	];

	if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
	{
		theScrollView.contentOffset = contentOffset; // Update content offset
	}
}

- (void)updateToolbarBookmarkIcon
{
	NSInteger page = [document.pageNumber integerValue];

	BOOL bookmarked = [document.bookmarks containsIndex:page];

	[mainToolbar setBookmarkState:bookmarked]; // Update
}

//读取PDF 对应的文件页面 显示给用户
- (void)showDocumentPage:(NSInteger)page
{
	if (page != currentPage) // Only if different
	{
		NSInteger minValue; NSInteger maxValue;
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1;

        //注意这个需要修改下参数 多加预加载几张PDF的界面信息
		if ((page < minPage) || (page > maxPage))
            
            return;

		if (maxPage <= PAGING_VIEWS) // Few pages  修改预加载pages
		{
			minValue = minPage;
			maxValue = maxPage;
		}
		else // Handle more pages
		{
            //改为加载5个View的界面信息  后面根据实际的测试情况进行更改数据源信息
			minValue = (page - 1);
			maxValue = (page + 3);

			if (minValue < minPage)
				{
                    minValue=minValue+1; maxValue=maxValue+1;}
			else
				if (maxValue > maxPage)
					{minValue=minValue-1; maxValue=maxValue-1;}
		}

		NSMutableIndexSet *newPageSet = [NSMutableIndexSet new];

		NSMutableDictionary *unusedViews = [contentViews mutableCopy];

		CGRect viewRect = CGRectZero;
        
        viewRect.size = theScrollView.bounds.size; //这个给定的值是718 700的尺寸
        
        //定义一个临时的ViewRect
        CGRect tempRect=CGRectZero;
        tempRect.size=theScrollView.bounds.size;
        //修改ScrollView的size
        //718 * 700  现在要求 宽度不变  高度发生变化 填充整个屏幕的尺寸
        //594  842
        
        //这个必须要先知道viewRect的大小  然后猜可以加载信息的
        //加载上一次的PDFView信息
        //加载相邻的3张PDFView
        //注意ARC内存的问题
        ReaderContentPage  *tempContentView = [[ReaderContentPage alloc] initWithURL:document.fileURL page:1 password:document.password];
        
        //注意转成整数进行比较大小的 浮点数不好比较大小
        viewRect.size=CGSizeMake(viewRect.size.width, (int)(viewRect.size.width*tempContentView.frame.size.height/tempContentView.frame.size.width));
        
        self.pdfShowRect=viewRect;
        
		for (NSInteger number = minValue; number <= maxValue; number++)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key

			ReaderContentView *contentView = [contentViews objectForKey:key];

			if (contentView == nil) // Create a brand new document content view
			{
				NSURL *fileURL = document.fileURL;
                
                NSString *phrase = document.password; // Document properties

				contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
                
                //contentView.pdfOffSet=tempRect.origin.y;

				[theScrollView addSubview:contentView];
                
                [contentViews setObject:contentView forKey:key];
                
                [contentMutArr addObject:contentView];

                //设置控制器的代理对象
				contentView.message = self;
                
                [newPageSet addIndex:number];
			}
			else // Reposition the existing content view
			{
				contentView.frame = viewRect;
                
                //contentView.pdfOffSet=tempRect.origin.y;
                
                [contentView zoomReset];

				[unusedViews removeObjectForKey:key];
			}

			viewRect.origin.y += viewRect.size.height;
            //0--1017--2034--3051--4068
            //tempRect.origin.y += tempRect.size.height;
		}

		[unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
			^(id key, id object, BOOL *stop)
			{
				[contentViews removeObjectForKey:key];

				ReaderContentView *contentView = object;

				[contentView removeFromSuperview];
			}
		];

		unusedViews = nil; // Release unused views

        //更新contentOffset
		CGFloat viewHeightX1 = viewRect.size.height;
		CGFloat viewHeightX2 = (viewHeightX1 * 2.0f);
        
		CGPoint contentOffset = CGPointZero;

		if (maxPage >= PAGING_VIEWS)
		{
			if (page == maxPage)
				contentOffset.y = viewHeightX2;
			else
				if (page != minPage)
					contentOffset.y = viewHeightX1;
		}
		else
			if (page == (PAGING_VIEWS - 1))
				contentOffset.y = viewHeightX1;

		if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
		{
			theScrollView.contentOffset = contentOffset; // Update content offset
            
            //self.next5Page=NO;
		}

		if ([document.pageNumber integerValue] != page) // Only if different
		{
			document.pageNumber = [NSNumber numberWithInteger:page]; // Update page number
		}

		NSURL *fileURL = document.fileURL;
        
        NSString *phrase = document.password;
        
        NSString *guid = document.guid;

		if ([newPageSet containsIndex:page] == YES) // Preview visible page first
		{
			NSNumber *key = [NSNumber numberWithInteger:page]; // # key

			ReaderContentView *targetView = [contentViews objectForKey:key];

			[targetView showPageThumb:fileURL page:page password:phrase guid:guid];

			[newPageSet removeIndex:page]; // Remove visible page from set
		}

		[newPageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock: // Show previews
			^(NSUInteger number, BOOL *stop)
			{
				NSNumber *key = [NSNumber numberWithInteger:number]; // # key

				ReaderContentView *targetView = [contentViews objectForKey:key];

				[targetView showPageThumb:fileURL page:number password:phrase guid:guid];
			}
		];

		newPageSet = nil; // Release new page set

		[mainPagebar updatePagebar]; // Update the pagebar display

		[self updateToolbarBookmarkIcon]; // Update bookmark

		currentPage = page; // Track current page number
	}
}

- (void)showDocument:(id)object
{
	[self updateScrollViewContentSize]; // Set content size
    
    //读取文档相关信息给scrollView
	[self showDocumentPage:[document.pageNumber integerValue]];

    //更新文档的打开时间
	document.lastOpen = [NSDate date]; // Update last opened date

	isVisible = YES; // iOS present modal bodge
}

#pragma mark UIViewController methods

- (id)initWithReaderDocument:(ReaderDocument *)object
{
	id reader = nil; // ReaderViewController object

	if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]]))
	{
		if ((self = [super initWithNibName:nil bundle:nil])) // Designated initializer
		{
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillTerminateNotification object:nil];

			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillResignActiveNotification object:nil];

			[object updateProperties];
            
            document = object; // Retain the supplied ReaderDocument object for our use

            //获取缩略图相关的信息
			[ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory

			reader = self; // Return an initialized ReaderViewController object
		}
	}

	return reader;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //现实Pdf的界面位置
    self.pdfShowRect=CGRectZero;
    
    self.previousOffSet=CGPointZero;
    
    //初始值为0的情况
    firstViewIndex=0;
    
    self.next5Page=NO;

	assert(document != nil); // Must have a valid ReaderDocument

	self.view.backgroundColor = [UIColor grayColor]; // Neutral gray

	CGRect scrollViewRect = self.view.bounds;
    
    UIView *fakeStatusBar = nil;

    //注意IOS7 存在的问题
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
	{
		if ([self prefersStatusBarHidden] == NO) // Visible status bar
		{
			CGRect statusBarRect = self.view.bounds; // Status bar frame
            
			statusBarRect.size.height = STATUS_HEIGHT; // Default status height
			fakeStatusBar = [[UIView alloc] initWithFrame:statusBarRect]; // UIView
			fakeStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			fakeStatusBar.backgroundColor = [UIColor blackColor];
			fakeStatusBar.contentMode = UIViewContentModeRedraw;
			fakeStatusBar.userInteractionEnabled = NO;
            //修改状态栏的高度 下移20个像素信息 同时scrollView上移20个像素
			scrollViewRect.origin.y += STATUS_HEIGHT; scrollViewRect.size.height -= STATUS_HEIGHT;
		}
	}
    //初始化底层的ScrollView状态  这个宽度定为718 高度可以改变
	theScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect]; // UIScrollView
	theScrollView.autoresizesSubviews = NO;
    theScrollView.contentMode = UIViewContentModeRedraw;
	theScrollView.showsHorizontalScrollIndicator = NO;
    theScrollView.showsVerticalScrollIndicator = NO;
	theScrollView.scrollsToTop = NO;
    theScrollView.delaysContentTouches = NO;
    //这个Page属性进行关闭
    theScrollView.pagingEnabled = NO;
	theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	theScrollView.backgroundColor = [UIColor clearColor];
    theScrollView.delegate = self;
	[self.view addSubview:theScrollView];

	CGRect toolbarRect = scrollViewRect; // Toolbar frame
	toolbarRect.size.height = TOOLBAR_HEIGHT; // Default toolbar height
	mainToolbar = [[ReaderMainToolbar alloc] initWithFrame:toolbarRect document:document]; // ReaderMainToolbar
	mainToolbar.delegate = self; // ReaderMainToolbarDelegate
	[self.view addSubview:mainToolbar];

	CGRect pagebarRect = self.view.bounds;; // Pagebar frame
	pagebarRect.origin.y = (pagebarRect.size.height - PAGEBAR_HEIGHT);
	pagebarRect.size.height = PAGEBAR_HEIGHT; // Default pagebar height
	mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:pagebarRect document:document]; // ReaderMainPagebar
	mainPagebar.delegate = self; // ReaderMainPagebarDelegate
	[self.view addSubview:mainPagebar];

	if (fakeStatusBar != nil)
        [self.view addSubview:fakeStatusBar]; // Add status bar background view

	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1;
    singleTapOne.numberOfTapsRequired = 1;
    singleTapOne.delegate = self;
	[self.view addGestureRecognizer:singleTapOne];

    //双击放大PDF信息
	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1;
    doubleTapOne.numberOfTapsRequired = 2;
    doubleTapOne.delegate = self;
	[self.view addGestureRecognizer:doubleTapOne];

    //2个点触摸执行的事件信息
	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2;
    doubleTapTwo.numberOfTapsRequired = 2;
    doubleTapTwo.delegate = self;
	[self.view addGestureRecognizer:doubleTapTwo];

	[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail

	contentViews = [NSMutableDictionary new];
    
    //初始化重用的可变数组对象
    contentMutArr=[NSMutableArray new];
    
    lastHideTime = [NSDate date];
    
    //开始初始化时就隐藏 ToolBar和PageBar
    [mainToolbar hideToolbar];
    [mainPagebar hidePagebar]; // Hide
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
			[self updateScrollViewContentViews]; // Update content views
		}

		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero)) // First time
	{
		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
	}

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = YES;

#endif // end of READER_DISABLE_IDLE Option
}

//阅读时不锁屏  或者阅读时锁屏
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	lastAppearSize = self.view.bounds.size; // Track view size

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = NO;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	mainToolbar = nil; mainPagebar = nil;

	theScrollView = nil; contentViews = nil; lastHideTime = nil;

	lastAppearSize = CGSizeZero; currentPage = 0;

	[super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	if (isVisible == NO) return; // iOS present modal bodge
//
//	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//	{
//		if (printInteraction != nil) [printInteraction dismissAnimated:NO];
//	}
//}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
//{
//	if (isVisible == NO) return; // iOS present modal bodge
//
//	[self updateScrollViewContentViews]; // Update content views
//
//	lastAppearSize = CGSizeZero; // Reset view size tracking
//}

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//if (isVisible == NO) return; // iOS present modal bodge

	//if (fromInterfaceOrientation == self.interfaceOrientation) return;
}
*/

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)loadPdfView:(float)offsetY{
    __block NSInteger page = 0;
    [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
     ^(id key, id object, BOOL *stop)
     {
         ReaderContentView *contentView = object;
         //修改一个系数的么
         //用==判断会不准确的 直接滑到第2页时进行加载数据信息
         //滑到到第3页时加载后面的5页数据信息的吧
         //317+1017
         //self.pdfShowRect.size.height*2
         if (contentView.frame.origin.y == offsetY)
         {
             NSLog(@"DidEndDecelerating%@__tag%ld",contentView,(long)contentView.tag);
             page = contentView.tag; *stop = YES;
//             self.next5Page=YES;
         }
     }
     ];
    if (page != 0)
        [self showDocumentPage:page]; // Show the page
}


//开始改变界面View的相对位置信息的么
//- (void)moveIndexInViewsWithDirect:(BOOL)forward{
//    
////    [UIView setAnimationsEnabled:NO];
//    //向下滑动事件
//    if (forward) {
//        
//        for (int i = firstViewIndex; i < (firstViewIndex + 2); i++) {
//            
//            MyView *subView = [_aryViews objectAtIndex:i%sMyViewTotal];
//            
//            subView.showNumber = subView.showNumber + sMyViewTotal;
//            
//            subView.frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y + (sMyViewTotal/2) * (sMyViewHeight + sMyViewGap), subView.frame.size.width, subView.frame.size.height);
//            
//        }
//        
//        firstViewIndex = (firstViewIndex + 2)%sMyViewTotal;
//        
//    }
//    
//    else{
//        
//        int lastViewIndex = firstViewIndex + sMyViewTotal - 1;
//        
//        for (int i = lastViewIndex; i > (lastViewIndex - 2); i--) {            MyView *subView = [_aryViews objectAtIndex:(firstViewIndex + sMyViewTotal - i)%sMyViewTotal];
//            
//            subView.showNumber = subView.showNumber - sMyViewTotal;
//            
//            subView.frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y - (sMyViewTotal/2) * (sMyViewHeight + sMyViewGap), subView.frame.size.width, subView.frame.size.height);
//            
//        }
//        
//        firstViewIndex = (firstViewIndex + sMyViewTotal - 2)%sMyViewTotal;
//        
//    }
//    
////    [UIView setAnimationsEnabled:YES];
//    
//}

#pragma mark 采用重用去实现滑动的机制的
-(void)scrollViewScrollow:(UIScrollView *)scrollView{
    BOOL directDown=NO;
    if (self.previousOffSet.y < scrollView.contentOffset.y) {
        directDown = YES;
    }
    else{
        directDown = NO;
    }
    _previousOffSet.y = scrollView.contentOffset.y;
    
    //防止最开始就向上面拖动的时候，改变数组视图树的位置。
    
    if (scrollView.contentOffset.y < 0) {
        
        return;
    }
    if (directDown) {
        //向下滑动
        NSLog(@"down");
        
        //firstViewIndex 第一个View的索引值
        ReaderContentView *readContentView= [contentMutArr objectAtIndex:firstViewIndex];
        
        CGFloat firstViewYOffset = readContentView.frame.origin.y + readContentView.frame.size.height;
        
        //寻找第一个视图是否滚动出去
        
        if (firstViewYOffset < scrollView.contentOffset.y) {
            
            //第一个视图已经滚动出去了
            //[self moveIndexInViewsWithDirect:YES];
        }
    }
    
    else{
        //向上滑动对象
        NSLog(@"up");
//        ReaderContentView * subView = [contentMutArr objectAtIndex:(firstViewIndex + sMyViewTotal - 2)%sMyViewTotal];
//        
//        CGFloat lastViewYOffset = subView.frame.origin.y - scrollView.bounds.size.height;
//        
//        if (lastViewYOffset > scrollView.contentOffset.y) {
//            
//            [self moveIndexInViewsWithDirect:NO];
//            
//        }
        
    }
    
}


#pragma mark UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    CGFloat pageWidth;
//    //int currentPage = ;
//    pageWidth = 700.0f;
//    int page = floor((scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
//    if (currentPage != page && currentPage != page + 1 && currentPage != page - 1){
//        //[self showDocumentPage:page fastScroll:YES];
//        if (page != 0)
//            [self showDocumentPage:page]; // Show the page
//    }

    
    
    //这个加载有点麻烦的呢
    //在滑到第1页时 就开始加载后面的5页的信息
    
//	CGFloat contentOffsetY = scrollView.contentOffset.y;
//    
//    //注意contentOffset也需要更新下数值的
//    NSLog(@"contentOffsetY %f",contentOffsetY);
    //第2页数据信息加载
    //滑到到了第3页数据信息的
    //这个要采用变量处理的么
    //317=1017-700的情况
//    if (contentOffsetY>0 && contentOffsetY<317 && self.next5Page==NO) {
//        //加载1到5页
//        [self loadPdfView:0];
////        self.next5Page=YES;
//    }
//    else
    
//    if ((317)<contentOffsetY && contentOffsetY<(1017+317) && self.next5Page==NO) {
//        //加载第2张到6页数据
//        //
//        [self loadPdfView:self.pdfShowRect.size.height];
//        self.next5Page=YES;
//    }
    
//    else if((317+1017)<contentOffsetY && contentOffsetY<(1017*2+317)){
//        [self loadPdfView:self.pdfShowRect.size.height*2];
//    }else if((317+1017*2)<contentOffsetY && contentOffsetY<(1017*3+317)){
//        [self loadPdfView:self.pdfShowRect.size.height*3];
//    }else if ((317+1017*3)<contentOffsetY && contentOffsetY<(1017*4+317)){
//        //4*1017
//        [self loadPdfView:self.pdfShowRect.size.height*4];
//    }
}

//注意是循环性的加载到ScrollView中去的 不是按顺序加载的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//   //注意有上滑动和下滑动的情况
//    __block NSInteger page = 0;
//    
//	CGFloat contentOffsetY = scrollView.contentOffset.y;
//    
//    //注意contentOffset也需要更新下数值的
//    NSLog(@"contentOffsetY %f",contentOffsetY);
//	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
//     ^(id key, id object, BOOL *stop)
//     {
//         ReaderContentView *contentView = object;
//         NSLog(@"ContentView_y%f",contentView.frame.origin.y);
//         //修改一个系数的么
//         //用==判断会不准确的
//         //非固定的页进行滑到怎么弄
//         if (contentView.frame.origin.y == contentOffsetY+700)
//         {
//             NSLog(@"DidEndDecelerating%@",contentView);
//             page = contentView.tag; *stop = YES;
//         }
//     }
//     ];
//	if (page != 0)
//        [self showDocumentPage:page]; // Show the page
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"DidEndScrollingAnimation");
	[self showDocumentPage:theScrollView.tag]; // Show page

	theScrollView.tag = 0; // Clear page number tag
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    //只响应UIScrollView的手势
	if ([touch.view isKindOfClass:[UIScrollView class]])
        return YES;

	return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)decrementPageNumber
{
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum

		if ((maxPage > minPage) && (page != minPage))
		{
			CGPoint contentOffset = theScrollView.contentOffset;

			contentOffset.x -= theScrollView.bounds.size.width; // -= 1

			[theScrollView setContentOffset:contentOffset animated:YES];

			theScrollView.tag = (page - 1); // Decrement page number
		}
	}
}

- (void)incrementPageNumber
{
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum

		if ((maxPage > minPage) && (page != maxPage))
		{
			CGPoint contentOffset = theScrollView.contentOffset;

			contentOffset.x += theScrollView.bounds.size.width; // += 1

			[theScrollView setContentOffset:contentOffset animated:YES];

			theScrollView.tag = (page + 1); // Increment page number
		}
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view];

		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area

		if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
		{
			NSInteger page = [document.pageNumber integerValue]; // Current page #

			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key];

			id target = [targetView processSingleTap:recognizer]; // Target

			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object

					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string

						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [NSString stringWithFormat:@"http://%@", www];

							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}

					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
						#ifdef DEBUG
							NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
						#endif
					}
				}
				else // Not a URL, so check for other possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger value = [target integerValue]; // Number

						[self showDocumentPage:value]; // Show the page
					}
				}
			}
			else // Nothing active tapped in the target content view
			{
				if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
				{
					if ((mainToolbar.hidden == YES) || (mainPagebar.hidden == YES))
					{
						[mainToolbar showToolbar];
                        [mainPagebar showPagebar]; // Show
                        
                        
					}
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber];
            
            return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber];
            
            return;
		}
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view];

		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);

		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = [document.pageNumber integerValue]; // Current page #

			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key];

			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[targetView zoomIncrement]; break;
				}

				case 2: // Two finger double tap: zoom --
				{
					[targetView zoomDecrement]; break;
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

#pragma mark ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
	if ((mainToolbar.hidden == NO) || (mainPagebar.hidden == NO))
	{
		if (touches.count == 1) // Single touches only
		{
			UITouch *touch = [touches anyObject]; // Touch info

			CGPoint point = [touch locationInView:self.view]; // Touch location

			CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);

			if (CGRectContainsPoint(areaRect, point) == false)
            
            return;
		}

		[mainToolbar hideToolbar];
        [mainPagebar hidePagebar]; // Hide

		lastHideTime = [NSDate date];
	}
}

#pragma mark ReaderMainToolbarDelegate methods

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (READER_STANDALONE == FALSE) // Option

	[document saveReaderDocument]; // Save any ReaderDocument object changes

	[[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:document.guid];

	[[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache

	if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss

	if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
	{
		[delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
	}
	else // We have a "Delegate must respond to -dismissReaderViewController: error"
	{
		NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
	}

#endif // end of READER_STANDALONE Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button
{
	if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss

	ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:document];

	thumbsViewController.delegate = self; thumbsViewController.title = self.title;

	thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;

	[self presentViewController:thumbsViewController animated:NO completion:NULL];
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button
{
#if (READER_ENABLE_PRINT == TRUE) // Option

	Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");

	if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
	{
		NSURL *fileURL = document.fileURL; // Document file URL

		printInteraction = [printInteractionController sharedPrintController];

		if ([printInteractionController canPrintURL:fileURL] == YES) // Check first
		{
			UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];

			printInfo.duplex = UIPrintInfoDuplexLongEdge;
			printInfo.outputType = UIPrintInfoOutputGeneral;
			printInfo.jobName = document.fileName;

			printInteraction.printInfo = printInfo;
			printInteraction.printingItem = fileURL;
			printInteraction.showsPageRange = YES;

			if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
			{
				[printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
			else // Presume UIUserInterfaceIdiomPhone
			{
				[printInteraction presentAnimated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
		}
	}

#endif // end of READER_ENABLE_PRINT Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button
{
#if (READER_ENABLE_MAIL == TRUE) // Option

	if ([MFMailComposeViewController canSendMail] == NO) return;

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	unsigned long long fileSize = [document.fileSize unsignedLongLongValue];

	if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
	{
		NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName; // Document

		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];

		if (attachment != nil) // Ensure that we have valid document file attachment data
		{
			MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

			[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];

			[mailComposer setSubject:fileName]; // Use the document file name for the subject

			mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;

			mailComposer.mailComposeDelegate = self; // Set the delegate

			[self presentViewController:mailComposer animated:YES completion:NULL];
		}
	}

#endif // end of READER_ENABLE_MAIL Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button
{
	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	NSInteger page = [document.pageNumber integerValue];

	if ([document.bookmarks containsIndex:page]) // Remove bookmark
	{
		[mainToolbar setBookmarkState:NO]; [document.bookmarks removeIndex:page];
	}
	else // Add the bookmarked page index to the bookmarks set
	{
		[mainToolbar setBookmarkState:YES]; [document.bookmarks addIndex:page];
	}
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	#ifdef DEBUG
		if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
	#endif

	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}

#pragma mark ThumbsViewControllerDelegate methods

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
	[self updateToolbarBookmarkIcon]; // Update bookmark icon

	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
	[self showDocumentPage:page]; // Show the page
}

#pragma mark ReaderMainPagebarDelegate methods

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
{
	[self showDocumentPage:page]; // Show the page
}

#pragma mark UIApplication notification methods

- (void)applicationWill:(NSNotification *)notification
{
	[document saveReaderDocument]; // Save any ReaderDocument object changes

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		if (printInteraction != nil) [printInteraction dismissAnimated:NO];
	}
}

@end
