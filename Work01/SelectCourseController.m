//
//  SelectCourseController.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SelectCourseController.h"
#import "GetXML.h"
#import "FirstLevel.h"
#import "PDFReadController.h"

#import "KWJCourseAlertView.h"
#import "KWJDownFile.h"
#import "KWJDownProgress.h"

#import "KWJHandleSQL.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"

#import "AppDelegate.h"

//快速预览组件
//#import <QuickLook/QuickLook.h>

#import "BrowserViewController.h"

#define XMLPATH @"http://ccmc-ccmc.stor.sinaapp.com/Course"
#define COURSEPATH @"http://ccmc-ccmc.stor.sinaapp.com/Course"

@interface SelectCourseController()
@property (nonatomic) NSMutableArray *firstLevelArray;

@property (nonatomic,copy)NSString *QLPreviewURL;

@property (nonatomic,copy)NSString *typeWare;

@property (nonatomic,strong)KWJHandleSQL *courseware;

@end

@implementation SelectCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTableView.sectionHeaderHeight = 50;
    _mainTableView.rowHeight = 44;
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除cell的分隔线
    
    GetXML *getXml = [GetXML getXMLWithDelegate:self];
    NSArray *array = @[@"firstLevel",@"secondLevel",@"word",@"ppt",@"video",@"pdf"];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.xml",XMLPATH,_courseId,_courseId];
    [getXml GetXML_Path:path title:array];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.courseware = [[KWJHandleSQL alloc] initDBName:@"dbzk.sqlite"];
    self.courseware = appDelegate.mySQL;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"coursewareTitle"] = @"text";
    dic[@"coursewareName"] = @"text";
    dic[@"coursewareType"] = @"text";
    dic[@"access_token"] = @"text";
    dic[@"courseId"] = @"text";
    dic[@"filePath"] = @"text";
    [self.courseware creatTabel:@"t_courseware" key:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//xml解析完成  代理 调用
-(void)XMLDidEndDocument:(NSArray *)array{
    
    _firstLevelArray = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        NSArray *tempArray = ((NSDictionary *)array[i])[@"firstLevel"];
        [_firstLevelArray addObject:[FirstLevel firstLevelWithArray:tempArray]];
    }
    
}

//加载tableview 数据
//分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _firstLevelArray.count;
}

//组中cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FirstLevel * f = _firstLevelArray[section];
    return f.isOpened?f.secondLevel.count:0;
}

//生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstLevel * f = _firstLevelArray[indexPath.section];
    
    SectionCell *cell = [SectionCell cellWithTableView:tableView];
    [cell setSecondLevel:f.secondLevel[indexPath.row] buttonDeleget:self];
    
    return cell;
}

//加载头部空间
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    KWJSectionHeaderView *header = [KWJSectionHeaderView headerViewWithTableView:tableView];
    header.delegates = self;
    [header setFirst:_firstLevelArray[section]];
    return header;
}

//头部控件 点击 代理事件
- (void)headerViewDidClickedMainView:(KWJSectionHeaderView *)headerView{
    [_mainTableView reloadData];
}

//cell 按钮点击 代理事件
-(void)labelButtonClick:(KWJLableButton *)button{
    KWJCourseAlertView *alert = [KWJCourseAlertView tableAlertWithTitle:button.title cancelButtonTitle:@"取消" courseware:button.coursewareArray delegate:self];
    _typeWare = button.title;
    [alert show];
}


-(void)cellSeleted:(KWJCourseAlertView *)alert couseware:(Courseware *)courseware index:(NSIndexPath *)index{
//        NSString *urls =  @"http:ccmc-ccmc.stor.sinaapp.com/Course/57/kwj.pdf"; 
    NSString *urls = [NSString stringWithFormat:@"%@/%@/%@",COURSEPATH,_courseId,courseware.path];
    
    if ([self fileDocumentPath:urls filePath:_typeWare plusName:[NSString stringWithFormat:@"%@%ld",_courseId,(long)index.row]]) {
        self.QLPreviewURL = [self fileDocumentPath:urls filePath:_typeWare plusName:[NSString stringWithFormat:@"%@%ld",_courseId,(long)index.row]];
        [self openWare];
    }else{
        KWJDownFile *downFile = [KWJDownFile initWithURL:[NSURL URLWithString:urls] FilePath:_typeWare plusName:[NSString stringWithFormat:@"%@%ld",_courseId,(long)index.row]];
        
        KWJDownProgress *downProgress = [KWJDownProgress progressWithTitle:@"开始下载在..."];
        
        downFile.downPlan = ^(float plan){
            [downProgress setProgress:plan];
        };
        
        [downProgress show];
        [downFile startAsyn];
        
        downFile.loadDidEnd = ^(NSString *path){
            self.QLPreviewURL = path;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"coursewareTitle"] = [NSString stringWithFormat:@"'%@'",courseware.title];
            dic[@"coursewareName"] = [NSString stringWithFormat:@"'%@'",_courseName];
            dic[@"coursewareType"] = [NSString stringWithFormat:@"'%@'",_typeWare];
            dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
            dic[@"courseId"] = [NSString stringWithFormat:@"'%@'",_courseId];
            dic[@"filePath"] = [NSString stringWithFormat:@"'%@'",path];
            [_courseware insertInto:@"t_courseware" value:dic];
            
            [self openWare];
        };
        
        
    }
}

-(void)openWare{
    [self comeToBrowser];
}

/*
 *  判断沙盒中是否 已有 请求的文件
 *
 *  @param url 请求文件的 url
 *
 *  @return 如果已有 返回 沙盒路径 没有返回nil
 */
-(NSString *)fileDocumentPath:(NSString *)url{
    
    NSURL *tempurl = [NSURL URLWithString:url];
    //创建 对应课件的 文件夹
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[tempurl lastPathComponent]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:savePath]) {
        return savePath;
    }else{
        return nil;
    }
}

/*
 *  判断沙盒中是否 已有 请求的文件
 *
 *  @param url 请求文件的 url
 *
 *  @return 如果已有 返回 沙盒路径 没有返回nil
 */
-(NSString *)fileDocumentPath:(NSString *)url filePath:(NSString *)path plusName:(NSString *)name{
    
    NSURL *tempurl = [NSURL URLWithString:url];
    //创建 对应课件的 文件夹
    NSString *tempName;
    
    if (name != nil) {
        tempName = [NSString stringWithFormat:@"%@_%@",name,[tempurl lastPathComponent]];
    }else{
        tempName = [NSString stringWithFormat:@"%@",[tempurl lastPathComponent]];
    }
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savePath;
    // = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[tempurl lastPathComponent]];
    if (path != nil) {
        savePath = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,path,tempName];
    }else{
        savePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,tempName];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:savePath]) {
        return savePath;
    }else{
//        NSLog(@"找不到对应文件");
        return nil;
    }
}

/*
 *  显示课件
 */
-(void)comeToBrowser{
    BrowserViewController *browser = [[BrowserViewController alloc] init];
    browser.hidesBottomBarWhenPushed = YES;
    browser.filePath = self.QLPreviewURL;
    browser.xmlPath = _courseId;
    browser.xmlName = _courseName;
    [self.navigationController pushViewController:browser animated:YES];
}

@end
