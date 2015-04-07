//
//  CoursewareTableViewController.m
//  Work01
//
//  Created by kwj on 14/12/26.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "CoursewareTableViewController.h"
#import "KWJCoursewareCell.h"
#import "KWJNULLCell.h"
#import "KWJHandleSQL.h"
#import "KWJAccountTool.h"
#import "KWJAccount.h"
#import "MyCourseware.h"
#import "BrowserViewController.h"
#import "KWJCoursewareHeader.h"
#import "AppDelegate.h"


@interface CoursewareTableViewController ()<KWJCoursewareHeaderDelegate>

@property (nonatomic,strong)KWJHandleSQL *courseware;

@property (nonatomic,strong)NSMutableArray *wordArray;
@property (nonatomic,strong)NSMutableArray *pptArray;
@property (nonatomic,strong)NSMutableArray *pdfArray;

@property (nonatomic,strong)NSMutableArray *showArray;
@property (nonatomic,strong)UIButton *selectBtn;

@property (nonatomic,strong)KWJCoursewareHeader *header;

@property (nonatomic,assign)BOOL cellCanSelect;

@end

@implementation CoursewareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.courseware = [[KWJHandleSQL alloc] initDBName:@"dbzk.sqlite"];
    self.courseware = appDelegate.mySQL;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
    dic[@"coursewareType"] = @"'word'";
    self.wordArray = [MyCourseware CoursewareWithStmt:[_courseware selectTabel:@"t_courseware" value:@[@" * "] where:dic]];
    dic[@"coursewareType"] = @"'ppt'";
    self.pptArray = [MyCourseware CoursewareWithStmt:[_courseware selectTabel:@"t_courseware" value:@[@" * "] where:dic]];
    dic[@"coursewareType"] = @"'pdf'";
    self.pdfArray = [MyCourseware CoursewareWithStmt:[_courseware selectTabel:@"t_courseware" value:@[@" * "] where:dic]];
    
    self.showArray = self.wordArray;
}

/*
 dic[@"coursewareName"]
 dic[@"coursewareType"]
 dic[@"access_token"]
 dic[@"courseId"]
 dic[@"filePath"]
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    int row;
    if (self.showArray.count > 0) {
        row = (int)self.showArray.count;
        self.cellCanSelect = YES;
    }else{
        row = 1;
        self.cellCanSelect = NO;
    }
    return row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellCanSelect) {
        KWJCoursewareCell *cell = [KWJCoursewareCell cellWithTableView:tableView];
        cell.courseware = self.showArray[indexPath.row];
        return cell;
    }else{
        KWJNULLCell *cell = [KWJNULLCell cellWithTableView:tableView];
        cell.title = @"没有内容";
        return cell;
    }
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyCourseware *temp = self.showArray[indexPath.row];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:temp.filePath error:&error];
        if (error == NULL) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"id"] = [NSString stringWithFormat:@"%d",temp.coursewareId];
            [_courseware deletesFrom:@"t_courseware" where:dic];
        }
        
        [self.showArray removeObjectAtIndex:indexPath.row];
        
        if (_showArray.count > 0) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [self.tableView reloadData];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellCanSelect) {
        MyCourseware *temp = self.showArray[indexPath.row];
        BrowserViewController *browser = [[BrowserViewController alloc] init];
        browser.filePath = temp.filePath;
        [self.navigationController pushViewController:browser animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        _header = [KWJCoursewareHeader headerViewWithTableView:tableView];
        _header.delegates = self;
        
        if (self.selectBtn == nil) {
            [_header setSelectedBtnWithTag:10000];
        }else{
            [_header setSelectedBtnWithTag:(int)self.selectBtn.tag];
        }
        
        return _header;
    }
    return nil;
}

-(void)headerBtnClick:(UIButton *)sender{

    self.selectBtn = sender;
    if ([sender.titleLabel.text isEqualToString:@"WORD"]) {
        self.showArray = self.wordArray;
    }else if ([sender.titleLabel.text isEqualToString:@"PPT"]){
        self.showArray = self.pptArray;
    }else if ([sender.titleLabel.text isEqualToString:@"PDF"]){
        self.showArray = self.pdfArray;
    }
    [self.tableView reloadData];
}


@end
