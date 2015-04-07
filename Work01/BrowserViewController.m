//
//  BrowserViewController.m
//  Work01
//
//  Created by kwj on 14/12/24.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "BrowserViewController.h"
#import "PublishStatusController.h"
#import <QuickLook/QuickLook.h>

#import "AppDelegate.h"
#import "KWJHandleSQL.h"

#import "KWJAccount.h"
#import "KWJAccountTool.h"

@interface BrowserViewController ()<UIActionSheetDelegate,QLPreviewControllerDataSource,
QLPreviewControllerDelegate>

@property (nonatomic,strong) QLPreviewController *previewController;

@property (nonatomic,strong) KWJHandleSQL *study;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSDate *begin;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"pdfTumb"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    _previewController = [[QLPreviewController alloc] init] ;
    _previewController.dataSource = self;
    _previewController.delegate = self;
    _previewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width , self.view.frame.size.height - 50);
    _previewController.currentPreviewItemIndex = 0;
    [self.view addSubview:_previewController.view];
    [_previewController reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.study = appDelegate.mySQL;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = @"text";
    dic[@"courseName"] = @"text";
    dic[@"courseId"] = @"text";
    dic[@"studyDay"] = @"text";
    dic[@"studyYear"] = @"text";
    dic[@"studyMonth"] = @"text";
    dic[@"studyBegin"] = @"text";
    dic[@"studyEnd"] = @"text";
    dic[@"studyTime"] = @"text";
    [self.study creatTabel:@"t_study" key:dic];
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    self.beginTime = [dateFormatter stringFromDate:[NSDate date]];
    self.begin = [NSDate date];

}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    NSURL *fileURL = [NSURL fileURLWithPath:_filePath];
    return fileURL;
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

-(void)rightBtnClick:(UIButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"功能" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:@"取消" otherButtonTitles:@"智库博文",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //取消
    }else if (buttonIndex == 1){
        //智库博文
        PublishStatusController *publish = [[PublishStatusController alloc] init];
//        publish.hidesBottomBarWhenPushed = YES;
        publish.xmlPath = _xmlPath;
        publish.xmlName = _xmlName;
        [self.navigationController pushViewController:publish animated:YES];
    }
//    NSLog(@"%ld",(long)buttonIndex);
}

/*
 *  退出课件浏览
 */
-(void)studyEnd{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    NSString *endTime = [dateFormatter stringFromDate:[NSDate date]];
    
    NSTimeInterval  timeInterval = [self.begin timeIntervalSinceNow];
    NSString *studyTime = [NSString stringWithFormat:@"%d",(int)-timeInterval];
    
    [dateFormatter setDateFormat: @"yyyy"];
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat: @"MM"];
    NSString *month = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat: @"dd"];
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
    dic[@"courseName"] = [NSString stringWithFormat:@"'%@'",_xmlName];
    dic[@"courseId"] = [NSString stringWithFormat:@"'%@'",_xmlPath];
    dic[@"studyDay"] = [NSString stringWithFormat:@"'%@'",day];
    dic[@"studyYear"] = [NSString stringWithFormat:@"'%@'",year];
    dic[@"studyMonth"] = [NSString stringWithFormat:@"'%@'",month];
    dic[@"studyBegin"]  = [NSString stringWithFormat:@"'%@'",self.beginTime];
    dic[@"studyEnd"] = [NSString stringWithFormat:@"'%@'",endTime];
    dic[@"studyTime"] = [NSString stringWithFormat:@"'%@'",studyTime];
    [self.study insertInto:@"t_study" value:dic];
}

-(void)dealloc{
    [self studyEnd];
}

@end
