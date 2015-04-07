//
//  TablePdfViewController.m
//  诺华云办公
//
//  Created by wangkw on 13-11-28.
//  Copyright (c) 2013年 CAC. All rights reserved.
//

#import "TablePdfViewController.h"
//#import "DocumentReadingViewController.h"
//#import "DocumentViewController.h"
//#import "MPAppDelegate.h"
//#import "UserDocInfo.h"
#define TAP_AREA_SIZE 48.0f

#define ZOOM_LEVELS 4

#if (READER_SHOW_SHADOWS == TRUE) // Option
#define CONTENT_INSET 4.0f
#else
#define CONTENT_INSET 2.0f
#endif // end of READER_SHOW_SHADOWS Option

@interface TablePdfViewController()

@end

@implementation TablePdfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化pdfData数组 添加用来显示的Pdf对象
    self.pdfDataArr=[NSMutableArray array];
    
    self.tableViewOffSet=CGPointZero;
    self.pdfShowRect=CGRectZero;
    self.lastPdfShowRect=CGRectZero;
    
//    docViewCon = [delegate getDocRootViewController];
    
    //添加自定义的PDF浏览页面类型
    //PDF的加载需要考虑内存的问题  缓存数据很重要的
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSString *filePath=self.pdfLocalPath;
    
    assert(filePath != nil); // Path to last PDF file
    
    //自定义的对象和系统传递过来的对象有关联的
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    //初始化对象填充数据源信息的
    if (document!=nil) {
        //更新document的属性信息
        
        self.doucmentObj=document;
        
        CGRect viewRect = CGRectZero;
        
        //viewRect.size = self.view.frame.size; //这个给定的值是718 700的尺寸
        
        ReaderContentPage  *tempContentView = [[ReaderContentPage alloc] initWithURL:document.fileURL page:1 password:document.password];
        
        //元数据源 大小
        self.pdfSourceRect=tempContentView.frame;
        
        viewRect.size=CGSizeMake(self.pdfWidth, (int)(self.pdfWidth*tempContentView.frame.size.height/tempContentView.frame.size.width));

        //算出给定的高度
        self.pdfShowRect=viewRect;
        
        for (NSInteger number = 0; number < [document.pageCount integerValue]; number++)
		{
            [self.pdfDataArr addObject:[NSNumber numberWithInteger:number]];
        }
    }
    
    
    //将手势添加到contentView中去的么
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
    [self.view addGestureRecognizer:singleTapOne];
    
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
    [self.view addGestureRecognizer:doubleTapOne];
    
    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
    [self.view addGestureRecognizer:doubleTapTwo];
    
    [singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
    
    [self updateMinimumMaximumZoom];
    
//    if (self.isShowToolBtn==NO) {
//        self.isShowToolBtn=YES;
//        [self.doucumentConObj hiderTopFourBtn];
//    }
    
    //判断开始的情况
    NSString *precentStr=nil;
    if (self.pdfShowRect.size.height>700) {
        float precent=(float)1/(float)self.pdfDataArr.count;
        precentStr=[NSString stringWithFormat:@"%d%@",(int)(precent*100),@"%"];
    }else {
        float tempCount=ceilf(700.0f/self.pdfShowRect.size.height);
        float precent=tempCount/self.pdfDataArr.count;
        precentStr=[NSString stringWithFormat:@"%d%@",(int)(precent*100),@"%"];
    }
//    NSString *currentId=[self.pdfLocalPath lastPathComponent];
//    if ([currentId isEqualToString:docViewCon.userInfo.DOC_ID]) {
//        docViewCon.userInfo.readingRecord = precentStr;
//    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.lastPdfShowRect.size.height>0) {
        float contentOffsetY=(self.pdfShowRect.size.height*self.tableViewOffSet.y)/self.lastPdfShowRect.size.height;
        [self.mainTableView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
    }else{
        [self.mainTableView setContentOffset:self.tableViewOffSet animated:YES];
    }
    
    //需要判断是否在加载缩略图的控制页面信息的
    if (self.isShowThumbView) {
        
        [self thumbViewShow];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.mainTableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.tableViewOffSet=self.mainTableView.contentOffset;
    NSArray *indexArr=[self.mainTableView indexPathsForVisibleRows];
    NSIndexPath *tempIndex=nil;
    if (indexArr.count==1) {
        tempIndex=indexArr[0];
    }else{
        tempIndex=indexArr[1];
    }
}

//显示缩略图信息
-(void)thumbViewShow{
    //缩略图需要判断 在各种不同的情况下的
    
    ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:self.doucmentObj];
    
    self.thumbsViewController=thumbsViewController;
    
    thumbsViewController.delegate = self;
    
    thumbsViewController.title = self.title;
    
    thumbsViewController.view.frame=self.view.frame;
    
    thumbsViewController.view.tag=8000;
    
    [self.view addSubview:thumbsViewController.view];
}

-(void)thumbViewHide{
    UIView *tempThumbView=[self.view viewWithTag:8000];
    [tempThumbView removeFromSuperview];
    
}

#pragma mark ThumbsViewControllerDelegate methods

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
    
	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
//
    [self.delegate hideThumbView];
    [self.mainTableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:page-1 inSection:0]atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //显示4个Button    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pdfDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //算出来的第一个高度信息
    return self.pdfShowRect.size.height;
}


//注意如果Cell过大  大于一个屏幕 就会出现2次重用的情况的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    NSURL *fileURL = self.doucmentObj.fileURL;
    
    NSString *phrase = self.doucmentObj.password; // Document properties
    
    //注意PDF数据的下标是从1开始的
    NSNumber *tempPageNum=self.pdfDataArr[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:self.pdfShowRect fileURL:fileURL page:[tempPageNum integerValue]+1 password:phrase];
        
        contentView.tag=3000;
        
        [cell addSubview:contentView];
        
//        [contentView release];
    }
    ReaderContentView *contentView =(ReaderContentView *)[cell viewWithTag:3000];
    //注意内存的释放很重要的
    
    ReaderContentPage *tempReader=[[ReaderContentPage alloc] initWithURL:fileURL page:[tempPageNum integerValue]+1 password:phrase];
    contentView.theContentView=tempReader;
//    [tempReader release];
    for (UIView *obj in [contentView.theContainerView subviews] ) {
        [obj removeFromSuperview];
    }
    [contentView.theContainerView addSubview:contentView.theContentView];
    
    return cell;
}

-(void)dealloc{
//    [_mainTableView release];
//    [_zoomScrollView release];
//    self.pdfDataArr=nil;
//    self.doucmentObj=nil;
//    self.thumbsViewController=nil;
//    if(docViewCon.userInfo != nil){
//        for(UserDocInfo * tempUserInfo in delegate.allUserDataSource){
//            if([docViewCon.userInfo.DOC_ID isEqualToString:tempUserInfo.DOC_ID]){
//                tempUserInfo.readingRecord = docViewCon.userInfo.readingRecord;
//                break;
//            }
//        }
//    }
//    [_mainTableView release];
//    [_zoomScrollView release];
//    [super dealloc];
}

//static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
//{
//	CGFloat w_scale = (target.width / source.width);
//    
//	CGFloat h_scale = (target.height / source.height);
//    
//	return ((w_scale < h_scale) ? w_scale : h_scale);
//}

//首先需要更新zoom的值
- (void)updateMinimumMaximumZoom
{    
	self.zoomScrollView.minimumZoomScale = 1.0; // Set the minimum and maximum zoom scales
    
	self.zoomScrollView.maximumZoomScale = ZOOM_LEVELS; // Max number of zoom levels
    
	contenViewZoomScale = ((self.zoomScrollView.maximumZoomScale - self.zoomScrollView.minimumZoomScale) / ZOOM_LEVELS);
}

- (void)zoomIncrement
{
	CGFloat zoomScale = self.zoomScrollView.zoomScale;
    
	if (zoomScale < self.zoomScrollView.maximumZoomScale)
	{
		zoomScale += contenViewZoomScale; // += value
        
		if (zoomScale > self.zoomScrollView.maximumZoomScale)
		{
			zoomScale = self.zoomScrollView.maximumZoomScale;
		}
        
		[self.zoomScrollView setZoomScale:zoomScale animated:YES];
        
	}
}


- (void)zoomDecrement
{
	CGFloat zoomScale = self.zoomScrollView.zoomScale;
    
	if (zoomScale > self.zoomScrollView.minimumZoomScale)
	{
		zoomScale -= contenViewZoomScale; // -= value
        
		if (zoomScale < self.zoomScrollView.minimumZoomScale)
		{
			zoomScale = self.zoomScrollView.minimumZoomScale;
		}

		[self.zoomScrollView setZoomScale:zoomScale animated:YES];
	}
}

#pragma mark GestureTap
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
        CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
//					[self zoomIncrement];
                    
//                    if (self.isShowToolBtn==NO) {
//                        self.isShowToolBtn=YES;
//                        [self.doucumentConObj hiderTopFourBtn];
//                    }else{
//                        self.isShowToolBtn=NO;
//                        [self.doucumentConObj showTopFourBtn];
//                    }
                    break;
				}
                    
				case 2: // Two finger double tap: zoom --
				{
					[self zoomDecrement];
                    break;
				}
			}
			return;
		}
    }
}

//手势实现
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[self zoomIncrement]; break;
				}
                    
				case 2: // Two finger double tap: zoom --
				{
					[self zoomDecrement]; break;
				}
			}
			return;
		}
    }
}

- (void)viewDidUnload {
    [self setMainTableView:nil];
    [self setZoomScrollView:nil];
    [self setMainTableView:nil];
    [self setZoomScrollView:nil];
    [super viewDidUnload];
}
@end
