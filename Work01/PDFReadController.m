//
//  PDFReadController.m
//  Work01
//
//  Created by kwj on 14/12/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "PDFReadController.h"
#import "TablePdfViewController.h"
#import "PublishStatusController.h"

@interface PDFReadController ()<hideThumbView,UIActionSheetDelegate>

@property (nonatomic,copy) NSString *actBtnTitle;

@end

@implementation PDFReadController

//创建文件夹
- (NSString *)getDocumentsDirectoryPath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:fileName];
    BOOL fileExists = [fileManager fileExistsAtPath:downloadPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:downloadPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return downloadPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actBtnTitle = @"预览";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"pdfTumb"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self showPDF];
}

-(void)rightBtnClick:(UIButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"功能" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:@"取消" otherButtonTitles:_actBtnTitle, @"智库博文",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //取消
    }else if (buttonIndex == 1){
        //预览/浏览
        if ([self.actBtnTitle isEqualToString:@"预览"]) {
            self.actBtnTitle = @"浏览";
            // 如何显示缩略图事件
            // 交换一个View去实现的
            [self.pdfTableView thumbViewShow];
        }else{
            self.actBtnTitle = @"预览";
            // 还原为单View的事件去实现
            [self.pdfTableView thumbViewHide];
        }
    }else if (buttonIndex == 2){
        //智库博文
        [self performSegueWithIdentifier:@"publishStatus" sender:nil];
    }
}




//    [self performSegueWithIdentifier:@"pdf" sender:urls];
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"publishStatus"]) {
        PublishStatusController *control = [segue destinationViewController];
        control.hidesBottomBarWhenPushed = YES;
        NSLog(@"prepareForSegue.....");
    }
}

-(void)showPDF{
    NSFileManager *fileManage=[NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_coursewareName];
    int length = (int)[_coursewareName rangeOfString:@"."].location;
    NSString *tempName = [_coursewareName substringWithRange:NSMakeRange(0, length)];
    NSString *fileDir=[self getDocumentsDirectoryPath:@"AAA"];//(原因不明 只能使用AAA为名字)
    
    NSString *destionPath=[fileDir stringByAppendingPathComponent:tempName];
    [fileManage copyItemAtPath:path toPath:destionPath error:nil];
    
    // 进入阅读PDF的显示界面 并设置他的框架大小
    TablePdfViewController *pdfTableView=[[TablePdfViewController alloc] initWithNibName:@"TablePdfViewController" bundle:nil];
    self.pdfTableView=pdfTableView;
    pdfTableView.pdfWidth=320;
    // 得到待阅读文件的地址
    
    self.pdfTableView.isShowThumbView=NO;
    pdfTableView.pdfLocalPath=destionPath;
    NSLog(@"%@",destionPath);
    pdfTableView.view.frame=self.readView.bounds;
    pdfTableView.delegate=self;
    //     pdfTableView.view.frame=CGRectMake(0, 30, 320, 420);
    
    [self.readView addSubview:pdfTableView.view];
    // Do any additional setup after loading the view, typically from a nib.
}

//tableOdfViewController 代理
-(void)hideThumbView{
    self.actBtnTitle = @"预览";
    // 还原为单View的事件去实现
    [self.pdfTableView thumbViewHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
