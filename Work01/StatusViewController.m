//
//  StatusViewController.m
//  Work01
//
//  Created by kwj on 14/12/8.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "StatusViewController.h"
#import "KWJStatusToolBar.h"
#import "KWJOneStatusCell.h"
#import "KWJStatusFrame.h"
#import "KWJAccountTool.h"
#import "KWJAccount.h"
#import "KWJComment.h"
#import "KWJCommentCell.h"
//转发微博
#import "RespotStatusViewController.h"
//评论微博
#import "CommentStatusController.h"

#import "KWJCommentFrame.h"
//得到 微博的评论
#define COMMENTURL @"https://api.weibo.com/2/comments/show.json"
/*
source	          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
access_token	  false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
id	              true	int64	需要查询的微博ID。
since_id	      false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
max_id	          false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
count	          false	int	    单页返回的记录条数，默认为50。
page	          false	int	    返回结果的页码，默认为1。
filter_by_author  false	int	    作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
 */
//得到 微博的转发
#define REPOSTURL  @"https://api.weibo.com/2/statuses/repost_timeline.json"

@interface StatusViewController ()

@property (nonatomic,strong)NSMutableArray *commentArray;//评价 数组
@property (nonatomic,strong)NSMutableArray *commentFrameArray;//评价 cell的尺寸

@property (nonatomic,strong)NSMutableArray *repostArray;//转发 数组
@property (nonatomic,strong)NSMutableArray *repostFrameArray;//转发 cell的尺寸

@property (nonatomic,strong)KWJStatusToolBar *tool;

//数据 加载
@property (nonatomic,strong)Loading *commentload;
@property (nonatomic,strong)Loading *repostload;

//group头部空间
@property (nonatomic,weak)KWJStatusHeaderView *header;

//默认 选中按钮
@property (nonatomic,assign)NSInteger selectedBtnTag;
@property (nonatomic) BOOL isComment;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@interface StatusViewController()<KWJStatusToolBarDelegate,RespotStatusViewControllerDelegate,commentStatusDelegate>

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //maintable 设置
//    self.mainTableView.estimatedSectionHeaderHeight = 10;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.bounces = NO;
//    self.mainTableView.scrollEnabled
    self.isComment = YES;
    
    self.selectedBtnTag = 10002;
    
    //加载数据
    [self getComments];
    
    //加载底部控制栏
    [self setupToolBar];
    
    
}

/*
 *  用户数据刷新
 *
 */
-(void)viewWillAppear:(BOOL)animated{
    //加载数据
//    if (_commentArray !=nil || _repostArray != nil) {
//        self.commentArray = [NSMutableArray array];
//        self.repostArray = [NSMutableArray array];
//        [self getComments];
//        [self getReposts];
//        [self.mainTableView reloadData];
//    }
}

/*
 *  请求 评论 数据
 */
-(void)getComments{
    if (_commentload == nil) {
        _commentload = [Loading LoadDBWithDelegate:self];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"id"] = _status.idstr;
    [_commentload LoadDB_GET_WithURL:COMMENTURL WithGet:dic WithName:@"comments" WithSender:nil];
}

/*
 *  请求 转发 数据
 */
-(void)getReposts{
    if (_repostload == nil) {
        _repostload = [Loading LoadDBWithDelegate:self];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"id"] = _status.idstr;
    [_repostload LoadDB_GET_WithURL:REPOSTURL WithGet:dic WithName:@"reposts" WithSender:nil];
}

/*
 *  刷新 评论 数据
 */
-(void)reComments{
    if (_commentload == nil) {
        _commentload = [Loading LoadDBWithDelegate:self];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"id"] = _status.idstr;
    dic[@"since_id"] = ((KWJStatus *)self.commentArray[0]).idstr;
    [_commentload LoadDB_GET_WithURL:COMMENTURL WithGet:dic WithName:@"recomments" WithSender:nil];
}

/*
 *  刷新 转发 数据
 */
-(void)reReposts{
    if (_repostload == nil) {
        _repostload = [Loading LoadDBWithDelegate:self];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"id"] = _status.idstr;
    [_repostload LoadDB_GET_WithURL:REPOSTURL WithGet:dic WithName:@"rereposts" WithSender:nil];
}

//联接 代理
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"comments"]) {
        NSDictionary *dic = (NSDictionary *)data;
        NSArray *array = dic[@"comments"];
        
        for (NSDictionary *dic in array) {
            //数据模型
            KWJComment *comment = [KWJComment commentWithDic:dic];
            [self.commentArray addObject:comment];
            //尺寸模型
            KWJCommentFrame *commentFrame = [[KWJCommentFrame alloc]init];
            commentFrame.comment = comment;
            [self.commentFrameArray addObject:commentFrame];
        }
        //更新评论数
        _status.comments_count = (int)self.commentArray.count;
    }else if ([name isEqualToString:@"reposts"]){
        NSDictionary *dic = (NSDictionary *)data;
        NSArray *array = dic[@"reposts"];
        
        for (NSDictionary *dic in array) {
            KWJComment *repost = [KWJComment commentWithDic:dic];
            [self.repostArray addObject:repost];
            
            KWJCommentFrame *repostFrame = [[KWJCommentFrame alloc]init];
            repostFrame.comment = repost;
            [self.repostFrameArray addObject:repostFrame];
        }
        //更新转发
        _status.reposts_count = (int)self.repostArray.count;
    }else if ([name isEqualToString:@"recomments"]){
        NSDictionary *dic = (NSDictionary *)data;
        NSArray *array = dic[@"comments"];
        if (array.count > 0) {
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:array];
            [temp addObjectsFromArray:self.commentArray];
            NSLog(@"temp %@",temp);
            self.commentArray = temp;
        }
    }else if ([name isEqualToString:@"rereposts"]){
        
    }
    
    [self.mainTableView reloadData];
}

/*
 *  创建底部工具条
 */
-(void)setupToolBar{
    KWJStatusToolBar *tool = [[KWJStatusToolBar alloc]init];
    CGFloat toolH = 50;
    CGFloat toolY = self.view.bounds.size.height - toolH;
//    CGFloat toolY = self.view.window.frame.size.height - toolH;
    CGFloat toolX = 0;
    CGFloat toolW = self.view.bounds.size.width;
    tool.frame = CGRectMake(toolX, toolY, toolW, toolH);
    tool.delegates = self;
    tool.status = self.status;
    [self.view addSubview:tool];
    self.tool = tool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = _isComment ? (int)self.commentArray.count : (int)self.repostArray.count;
    return section == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        KWJOneStatusCell *cell = [KWJOneStatusCell cellWithTableView:self.mainTableView];
        cell.statusFrame = self.statusFrame;
        return cell;
    }else{
          KWJCommentCell *cell = [KWJCommentCell cellWithTableView:self.mainTableView];
        if (_isComment) {
            cell.comment = self.commentArray[indexPath.row];
            cell.commentFrame = self.commentFrameArray[indexPath.row];
        }else{
            cell.comment = self.repostArray[indexPath.row];
            cell.commentFrame = self.repostFrameArray[indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _statusFrame.cellHeight_topView;
    }else if (self.commentFrameArray.count > 0){
        KWJCommentFrame *temp;
        if (_isComment) {
            temp = self.commentFrameArray[indexPath.row];
        }else{
            temp = self.repostFrameArray[indexPath.row];
        }
        
        return temp.cellH;
    }
    return 0;
}

/*
 *  toptool 各按钮的点击事件
 *
 *  @param send 点击的按钮
 */
-(void)toolBtnClicked:(UIButton *)send{
    self.selectedBtnTag = send.tag;
    
    if (send.tag == 10001) {
        [_header setSelectBtn:10001];
        //转发
        if (_isComment) {
            //跳转到转发
            _isComment = !_isComment;
            
            if (self.repostArray.count == 0) {
                //获取转发数据
                [self getReposts];
            }else{
                //刷新数据
                
            }
            [self.mainTableView reloadData];
        }
        
    }else if (send.tag == 10002){
        [_header setSelectBtn:10002];
        //评论
        if (!_isComment) {
            //跳转到 评论
            _isComment = !_isComment;
            
            if (self.commentArray.count == 0) {
                //请求数据
                [self getComments];
            }else{
                //刷新数据
//                [self reComments];
            }
            [self.mainTableView reloadData];
        }
        
    }else if (send.tag == 10003){
        //赞
        NSLog(@"赞");
        
    }
}

/*
 *  底部 三个按钮 控件 代理
 *
 *  @param sender 按钮
 *  @param status 微博
 */
-(void)toolBarBtnClick:(UIButton *)sender status:(KWJStatus *)status{
//    NSLog(@"%ld",(long)sender.tag);
    int tag = (int)sender.tag;
    if (tag == 10001) {
        //转发
        [self performSegueWithIdentifier:@"zhuanfa" sender:nil];
    }else if (tag == 10002){
        //评论
        CommentStatusController *comment = [[CommentStatusController alloc] init];
        comment.hidesBottomBarWhenPushed = YES;
        comment.statusId = self.status.idstr;
        comment.delegates = self;
        [self.navigationController pushViewController: comment animated:true];
    }else if (tag == 10003){
        //赞
        
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"zhuanfa"]) {
        RespotStatusViewController *respot = [segue destinationViewController];
        respot.hidesBottomBarWhenPushed = YES;
        respot.delegates = self;
        respot.status = self.status;
    }
}

/*
 *  转发控件的代理 事件    评论控件的代理事件
 */
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 *  bottomtool 按钮点击事件
 *
 *  @param sender 点击的按钮
 */
-(void)bottomBoolClicked:(UIButton *)sender{
    NSLog(@"评论");
}

// 数组 初始化
-(NSMutableArray *)repostArray{
    if (_repostArray == nil) {
        _repostArray = [NSMutableArray array];
    }
    return _repostArray;
}
-(NSMutableArray *)repostFrameArray{
    if (_repostFrameArray == nil) {
        _repostFrameArray = [NSMutableArray array];
    }
    return _repostFrameArray;
}
-(NSMutableArray *)commentArray{
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
-(NSMutableArray *)commentFrameArray{
    if (_commentFrameArray == nil) {
        _commentFrameArray = [NSMutableArray array];
    }
    return _commentFrameArray;
}

/*
 *  头部控件
 *
 *  @param tableView tableview
 *  @param section   secion
 *
 *  @return 返回头部控件
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        //创建头部控件
        KWJStatusHeaderView *header =[KWJStatusHeaderView headerViewWithTableView:self.mainTableView topToolDelegate:self];
        //头部控件赋值
        header.status = _status;
        [header setSelectBtn:_selectedBtnTag];
        self.header = header;
        return header;
    }else{
        return nil;
    }
}

/*
 *设置每一个头部控件的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (self.commentArray.count > 0) {
            return 44;
        }else{
            return 88;
        }
    }
    return 10;
}

@end
