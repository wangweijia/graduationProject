//
//  CollectCourseTableViewController.m
//  Work01
//
//  Created by kwj on 14/12/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "CollectCourseTableViewController.h"
#import "KWJCollectCourseCell.h"
#import "KWJNULLCell.h"
#import "CollectCourse.h"
#import "SelectCourseController.h"
#import "AppDelegate.h"
#import "KWJAccountTool.h"
#import "KWJAccount.h"

#import "KWJHandleSQL.h"

@interface CollectCourseTableViewController ()<KWJCollectCourseCellDelegate>

@property (nonatomic,strong)NSArray *collectArray;

@property (nonatomic,strong)KWJHandleSQL *collect;

@property (nonatomic,assign)BOOL cellCanSelect;

@end

@implementation CollectCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
//    self.collect = [[KWJHandleSQL alloc] initDBName:@"dbzk.sqlite"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.collect = appDelegate.mySQL;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
    self.collectArray = [CollectCourse courseWithStmt:[_collect selectTabel:@"t_collect" value:@[@" * "] where:dic]];
}

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
    if (_collectArray.count > 0) {
        row = (int)_collectArray.count;
        self.cellCanSelect = YES;
    }else{
        row = 1;
        self.cellCanSelect = NO;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellCanSelect) {
        KWJCollectCourseCell *cell = [KWJCollectCourseCell cellWithTableView:tableView];
        cell.course = _collectArray[indexPath.row];
        cell.delegates = self;
        return cell;
    }else{
        KWJNULLCell *cell = [KWJNULLCell cellWithTableView:tableView];
        cell.title = @"没有收藏课件";
        return cell;
    }
    
}

-(void)cellectButtonClick:(CollectCourse *)course{
    if (![self isCollectCourse:course]) {
        //插入
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
        dic1[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
        dic1[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
        dic1[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
        dic1[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
        [_collect insertInto:@"t_collect" value:dic1];
    }else{
        //删除
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
        dic2[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
        dic2[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
        dic2[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
        dic2[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
        [_collect deletesFrom:@"t_collect" where:dic2];
    }
}

-(BOOL)isCollectCourse:(CollectCourse *)course{
    //查询
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
    dic3[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
    dic3[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
    dic3[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
    dic3[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
    if ([_collect selectTabel:@"t_collect" value:@[@" * "] where:dic3] == nil) {
        return NO;
    }else{
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellCanSelect) {
        CollectCourse *course = _collectArray[indexPath.row];
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelectCourseController *selectCourseController = [storyBoard instantiateViewControllerWithIdentifier:@"selectCourseController"];
        selectCourseController.courseId = course.courseId;
        selectCourseController.courseName = course.name;
        [self.navigationController pushViewController:selectCourseController animated:YES];
    }
}

@end
