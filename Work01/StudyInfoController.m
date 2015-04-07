//
//  StudyInfoController.m
//  Work01
//
//  Created by kwj on 15/1/12.
//  Copyright (c) 2015年 wwj. All rights reserved.
//

#import "StudyInfoController.h"
#import "KWJHandleSQL.h"
#import "AppDelegate.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"
#import "StudyInfo.h"
#import "KWJStudyInfoCell.h"
//#import <sqlite3.h>

@interface StudyInfoController ()

@property (nonatomic,strong) KWJHandleSQL *myStudy;

@property (nonatomic,strong) NSArray *studyInfo;

@end

@implementation StudyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myStudy = appDelegate.mySQL;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
//    [_myStudy selectTabel:@"t_study" value:@[@" * "] where:dic];
    self.studyInfo = [StudyInfo StudyInfoWithStmt:[_myStudy selectTabel:@"t_study" value:@[@" * "] where:dic]];

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

    return _studyInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KWJStudyInfoCell *cell = [KWJStudyInfoCell cellWithTableView:tableView];
    cell.studyInfo = _studyInfo[indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
