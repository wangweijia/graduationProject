//
//  UserViewController.m
//  Work01
//
//  Created by kwj on 14/11/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//


#import "UserViewController.h"
#import "CollectCourseTableViewController.h"
#import "CoursewareTableViewController.h"
#import "StudyInfoController.h"
#import "Loading.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"

#define UserShow @"https://api.weibo.com/2/users/show.json"
/*
 source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参      数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 uid	        false	int64	需要查询的用户ID。
 screen_name	false	string	需要查询的用户昵称。
 */

@interface UserViewController ()<LoadBDConnectionDataDelegate>

//用户 个人信息
@property (nonatomic) NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UITableViewCell *userTableViewCell;

@property (nonatomic,strong) Loading *userMessage;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.mainTableView.bounces = NO;
    self.tableView.bounces = NO;
    
    //加载用户个人信息
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user = [_defaults stringForKey:@"statusUser"];
    NSString *accessToken = [_defaults stringForKey:@"accessToken"];
    if (user == nil || ![accessToken isEqualToString:[KWJAccountTool account].access_token]) {
        self.userMessage = [Loading LoadDBWithDelegate:self];
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        dics[@"access_token"] = [KWJAccountTool account].access_token;
        dics[@"uid"] = [NSString stringWithFormat:@"%lld",[KWJAccountTool account].uid] ;
        [_userMessage LoadDB_GET_WithURL:UserShow WithGet:dics WithName:@"userMessage" WithSender:nil];
    }else{
        _userTableViewCell.textLabel.text = user;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"userMessage"]) {
        NSDictionary *dic = data;
        _userTableViewCell.textLabel.text = dic[@"name"];
        [_userTableViewCell reloadInputViews];
        [_defaults setObject:dic[@"name"] forKey:@"statusUser"];
        [_defaults setObject:[KWJAccountTool account].access_token forKey:@"accessToken"];
    }
}

//cell 选中 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"账号管理" delegate:self cancelButtonTitle:@"123" destructiveButtonTitle:@"321" otherButtonTitles:@"132", nil];
    
    switch (cell.tag) {
        case 10001:
            //点击用户
            break;
        case 10002:
            //我的收藏
            [self comeToCollectCourse];
            break;
        case 10003:
            //我的课件管理
            [self comeToCollectCourseware];
            break;
        case 10004:
            //学习记录
            [self comeToStudyInfo];
            break;
        case 10005:{
            //账号管理
            UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"账号管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更换账号", nil];
            [action showInView:self.view];
            break;
        }
    
        default:
            break;
    }
}

/*
 *  收藏课程管理
 */
-(void)comeToCollectCourse{
    CollectCourseTableViewController *collect = [[CollectCourseTableViewController alloc] init];
//    [self.navigationController pushViewController:collect animated:YES];
    collect.navigationItem.title = @"课程收藏";
    [self.navigationController pushViewController:collect animated:YES];
}

/*
 *  个人课件管理
 */
-(void)comeToCollectCourseware{
    CoursewareTableViewController *courseware = [[CoursewareTableViewController alloc] init];
    //    [self.navigationController pushViewController:collect animated:YES];
    courseware.navigationItem.title = @"课件管理";
    [self.navigationController pushViewController:courseware animated:YES];
}

/*
 *  个人学习记录
 */
-(void)comeToStudyInfo{
    StudyInfoController *studyInfo = [[StudyInfoController alloc] init];
    studyInfo.navigationItem.title = @"学习记录";
    [self.navigationController pushViewController:studyInfo animated:YES];
}


//uiactionsheet 代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //跟换账号
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"quit" object:nil];
            break;
        }
            
        default:
            break;
    }
}

@end
