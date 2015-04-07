//
//  ViewController.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//


#import "ViewController.h"
#import "KWJAccountTool.h"
#import "KWJAccount.h"
#import "Loading.h"
#import "UIImage+KWJ.h"
#import "KWJLoading.h"
#import "CommentStatusController.h"
#import "SelectCourseController.h"

//模型头文件
#import "KWJStatusFrame.h"
#import "KWJStatusUser.h"
#import "KWJStatus.h"

//共有宏 头文件
#import "HeaderFile.h"

//第三方控件
#import "MJRefresh.h"

#import "StatusViewController.h"
#import "RespotStatusViewController.h"

#define LOAD @"https://api.weibo.com/2/statuses/home_timeline.json"

#define SelfStatus @"1"

@interface ViewController ()<LoadBDConnectionDataDelegate,MJRefreshBaseViewDelegate,RespotStatusViewControllerDelegate,commentStatusDelegate>

@property (nonatomic) Loading *loading;

@property (nonatomic) Loading *load;

@property (nonatomic) NSMutableArray *status;

@property (nonatomic) NSMutableArray *statusFrames;

//下拉刷新控件
@property (nonatomic) UIRefreshControl *refreshControl;

//上拉刷新
@property (nonatomic) MJRefreshFooterView *freshFooterView;

@property (nonatomic) KWJLoading *statusLoading;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview 的设置
    //去除分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = KWJColor(226, 226, 226);
    
    //下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    // 监听刷新控件的状态改变
    [_refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:_refreshControl];
    
    //上拉刷新
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.mainTableView;
    footer.delegate = self;
    _freshFooterView = footer;
    
    // 2.加载微博数据
    [self setupStatusData];
}

- (void)refreshControlStateChange:(UIRefreshControl *)refreshControl{

    if (_status.count > 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"access_token"] = [KWJAccountTool account].access_token;
        dic[@"since_id"] = ((KWJStatus *)_status[0]).idstr;
        dic[@"base_app"] = SelfStatus;//是否只返回本app发送的数据
        
        [_load LoadDB_GET_WithURL:LOAD WithGet:dic WithName:@"reload" WithSender:nil];
    }else{
        // 2.加载微博数据
        [self setupStatusData];
    }
    
}

/*
 *  开始进入刷新状态就会调用
 *
 *  @param refreshView
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    KWJStatus *temp = [_status lastObject];
    long long maxid = [temp.idstr longLongValue] - 1;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"max_id"] = [NSString stringWithFormat:@"%lld",maxid];
    dic[@"base_app"] = SelfStatus;//是否只返回本app发送的数据
    [_load LoadDB_GET_WithURL:LOAD WithGet:dic WithName:@"moreload" WithSender:nil];
}

/*
 *  加载数据
 */
- (void)setupStatusData
{
    if (_statusLoading == nil) {
//        _statusLoading = [KWJLoading loadingWithTitle:@"正在加载数据。。。"];
        _statusLoading = [KWJLoading loadingWithTitle:@"正在加载数据。。。" ParentController:self.mainTableView];
    }
    BOOL isRefreshing = _refreshControl.isRefreshing;

    //防止block循环调用
    __block ViewController *viewController = self;
    _statusLoading.outTime = ^(void){
        if (isRefreshing) {
            //关闭滚轮
            [viewController.refreshControl endRefreshing];
        }
    };
    [_statusLoading show];
    _load = [Loading LoadDBWithDelegate:self];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"base_app"] = SelfStatus;//是否只返回本app发送的数据
    [_load LoadDB_GET_WithURL:LOAD WithGet:dic WithName:@"load" WithSender:nil];
}

/*
 *  请求数据 代理回调
 *
 *  @param data   返回的数据
 *  @param name   请求的名字
 *  @param sender 请求时附带的参数
 */
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    
    NSDictionary *dic = (NSDictionary *)data;
    NSArray *dicArray = dic[@"statuses"];
    NSMutableArray *statusArray = [NSMutableArray array];
    NSMutableArray *statusFrameArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dicArray) {
        //字典转换成模型
        KWJStatus *status = [KWJStatus statusWithDic:dic];
        [statusArray addObject:status];
        
        KWJStatusFrame *frame = [[KWJStatusFrame alloc]init];
        frame.status = status;
        [statusFrameArray addObject:frame];
    }
    
    //更具name的不同进行不同的操作
    if ([name isEqualToString:@"load"]) {
        _status = statusArray;
        _statusFrames = statusFrameArray;
        [_statusLoading stop];
        [_mainTableView reloadData];
    }else if ([name isEqualToString:@"reload"]){
        if (dicArray.count > 0) {
            //让新消息显示在头部
            [statusArray addObjectsFromArray:_status];
            [statusFrameArray addObjectsFromArray:_statusFrames];
            _status = statusArray;
            _statusFrames = statusFrameArray;
            
            [_mainTableView reloadData];
        }
        [self showNewStatusCount:(int)dicArray.count];
        //关闭滚轮
        [_refreshControl endRefreshing];
    }if ([name isEqualToString:@"moreload"]) {
        [_status addObjectsFromArray:statusArray];
        [_statusFrames addObjectsFromArray:statusFrameArray];
        
        [_mainTableView reloadData];
        //关闭滚轮
        [self.freshFooterView endRefreshing];
    }
    
}

/*
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(int)count{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
//    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    [self.view addSubview:btn];
    
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"共有%d条新的微博", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"没有新的微博数据" forState:UIControlStateNormal];
    }
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
//    CGFloat btnY = -btnH;
    CGFloat btnX = 5;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:1 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, btnH);
        
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:1 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _status.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KWJStatusCell *cell = [KWJStatusCell cellWithTableView:_mainTableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    [cell setStatusToolBarDelegate:self];
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KWJStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

-(void)dealloc{
    [self.freshFooterView free];
}

//页面跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"status"]) {
        NSIndexPath *index = sender;
        StatusViewController *vc = [segue destinationViewController];
        //隐藏下面的控制栏
        vc.hidesBottomBarWhenPushed = YES;
        [vc setStatus:_status[index.row]];
        [vc setStatusFrame:_statusFrames[index.row]];
    }else if ([segue.identifier isEqualToString:@"repotStstus"]){
        KWJStatus *statuss = (KWJStatus *)sender;
        RespotStatusViewController *rs = [segue destinationViewController];
        rs.hidesBottomBarWhenPushed = YES;
        rs.delegates = self;
        [rs setStatus:statuss];
    }
}

//cell 的点击 代理事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"status" sender:indexPath];
}

// 3个工具按钮的 代理点击事件
-(void)toolBarBtnClick:(UIButton *)sender status:(KWJStatus *)status{
    if (sender.tag == 10001) {
        //转发
        [self performSegueWithIdentifier:@"repotStstus" sender:status];
    }else if(sender.tag == 10002){
        //评论
        CommentStatusController *comment = [[CommentStatusController alloc] init];
        comment.hidesBottomBarWhenPushed = YES;
        comment.statusId = status.idstr;
        comment.delegates = self;
        [self.navigationController pushViewController: comment animated:true];
    }else if(sender.tag == 10003){
        //课件浏览
        if (status.xmlPath != nil ) {
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SelectCourseController *selectCourseController = [storyBoard instantiateViewControllerWithIdentifier:@"selectCourseController"];
            selectCourseController.courseId = status.xmlPath;
            selectCourseController.courseName = status.xmlName;
            [self.navigationController pushViewController:selectCourseController animated:YES];
        }
    }
}

//使push出去的页面返回
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
    [self refreshControlStateChange:_refreshControl];//返回后刷新数据
}
@end
