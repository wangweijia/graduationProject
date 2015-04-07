//
//  UserFriendsTableViewController.m
//  Work01
//
//  Created by kwj on 14/12/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "UserFriendsTableViewController.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"
#import "Loading.h"
#import "KWJFriends.h"
#import "pinyin.h"
#import "KWJSoreByInitial.h"
#import "KWJFriendCell.h"
#import "HeaderFile.h"

#define GETFRIENDS @"https://api.weibo.com/2/friendships/friends.json"
/*
 source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 uid	        false	int64	需要查询的用户UID。
 screen_name	false	string	需要查询的用户昵称。
 count	        false	int	    单页返回的记录条数，默认为50，最大不超过200。
 cursor	        false	int	    返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
 trim_status	false	int	    返回值中user字段中的status字段开关，0：返回完整status字段、1：status字段仅返回status_id，默认为1。
*/
/*    NSLog(@"%lld,%@",[KWJAccountTool account].uid,[KWJAccountTool account].access_token);
 5395766295,2.00dSFKtF0yavPY1b887e4048UfK1cD
 https://api.weibo.com/2/friendships/friends.json?access_token=2.00dSFKtF0yavPY1b887e4048UfK1cD&uid=5395766295
*/


@interface UserFriendsTableViewController ()<LoadBDConnectionDataDelegate>

@property (nonatomic,strong)NSMutableArray *friendsArray;

@property (nonatomic,strong)Loading *getFriends;

@property (nonatomic,strong)NSDictionary *letterDic;

@property (nonatomic,strong)NSArray *sortKeyArray;

@property (nonatomic,strong)NSMutableArray *selectFriends;

@end

@implementation UserFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.friendsArray = [NSMutableArray array];
    
    [self getAllFriend];
    
//    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftB.frame = CGRectMake(0, 0, 60, 0);
//    [leftB setTitle:@"返回" forState:UIControlStateNormal];
//    [leftB setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
////    [leftB addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftB];
//    [self.navigationItem setLeftBarButtonItem:leftB];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.frame = CGRectMake(0, 0, 60, 0);
    [rightB setTitle:@"确定" forState:UIControlStateNormal];
    [rightB setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightB addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightB];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBtnClick:(UIButton *)sender{
    if ([self.delegates respondsToSelector:@selector(returnSelectedFriends:)]) {
        [self.delegates returnSelectedFriends:self.selectFriends];
    }
}

-(void)getAllFriend{
    self.getFriends = [Loading LoadDBWithDelegate:self];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"uid"] = [NSString stringWithFormat:@"%lld",[KWJAccountTool account].uid];
    [self.getFriends LoadDB_GET_WithURL:GETFRIENDS WithGet:dic WithName:@"getFriend" WithSender:nil];
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"getFriend"]) {
        NSDictionary *dicF = (NSDictionary *)data;
        NSArray *f = dicF[@"users"];
        
        for (NSDictionary *d in f) {
            [self.friendsArray addObject:[KWJFriends friendsWithDict:d]];
        }
        
        NSDictionary *letterDic = [KWJSoreByInitial sortByInitial:self.friendsArray];
        self.letterDic = letterDic;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSArray *array = [self.letterDic allKeys];
    self.sortKeyArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    return array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.letterDic[self.sortKeyArray[section]];
//    NSLog(@"%ld",array.count);
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *someFriend = self.letterDic[self.sortKeyArray[indexPath.section]];
    KWJFriendCell *cell = [KWJFriendCell cellWithTableView:tableView];
    cell.friends = someFriend[indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sortKeyArray[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"...select");
    
    if (self.selectFriends == nil) {
        self.selectFriends = [NSMutableArray array];
    }
    
    NSArray *someFriend = self.letterDic[self.sortKeyArray[indexPath.section]];
    ((KWJFriends *)someFriend[indexPath.row]).isSelected = !((KWJFriends *)someFriend[indexPath.row]).isSelected;
    
    KWJFriendCell *cell = (KWJFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (((KWJFriends *)someFriend[indexPath.row]).isSelected) {
        [self.selectFriends addObject:((KWJFriends *)someFriend[indexPath.row]).name];
    }else{
        [self.selectFriends removeObject:((KWJFriends *)someFriend[indexPath.row]).name];
    }
    [cell cellIsSelected:((KWJFriends *)someFriend[indexPath.row]).isSelected];
}

@end
