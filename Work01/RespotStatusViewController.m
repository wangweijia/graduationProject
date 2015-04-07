//
//  RespotStatusViewController.m
//  Work01
//
//  Created by kwj on 14/12/12.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "RespotStatusViewController.h"
#import "RespotFrame.h"
#import "KWJRespot.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"
#import "Loading.h"
#import "KWJLoading.h"


//转发 微博
#define REPOSTSTATUS @"https://api.weibo.com/2/statuses/repost.json"


@interface RespotStatusViewController ()<LoadBDConnectionDataDelegate>

@property (nonatomic) KWJLoading *loading;

@property (nonatomic,strong) RespotFrame *respotFrame;

@property (nonatomic,strong) KWJRespot *respotView;

@property (nonatomic) Loading *load;

@end

@implementation RespotStatusViewController

- (void)viewDidLoad {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewDidLoad];
    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
    leftB.frame = CGRectMake(0, 0, 60, 0);
    [leftB setTitle:@"取消" forState:UIControlStateNormal];
    [leftB setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftB];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.frame = CGRectMake(0, 0, 60, 0);
    [rightB setTitle:@"发送" forState:UIControlStateNormal];
    [rightB setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightB addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightB];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    RespotFrame *respotFrame = [[RespotFrame alloc]init];
    respotFrame.selfW = self.view.bounds.size.width;
    respotFrame.status = _status;
    self.respotFrame = respotFrame;
    
    KWJRespot *respotView = [[KWJRespot alloc]init];
    respotView.respotFrame = self.respotFrame;
    [self.view addSubview:respotView];
    self.respotView = respotView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//navigation 左边按钮
-(void)leftBtnClick:(UIBarButtonItem *)sender{
    if ([self.delegates respondsToSelector:@selector(dismissSelf)]) {
        [self.delegates dismissSelf];
    }
}

//navigation 右边按钮
-(void)rightBtnClick:(UIBarButtonItem *)sender{
    /*
     source	       false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
     access_token  false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     id	           true	    int64	要转发的微博ID。
     status	       false	string	添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
     is_comment	   false	int	    是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
     rip	       false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
     */
    
    if (self.load == nil) {
        self.load = [Loading LoadDBWithDelegate:self];
        _loading = [KWJLoading loadingWithTitle:@"转发中..."];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"id"] = _status.idstr;
//    [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dic[@"status"] = [self.respotView.respotText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.load LoadDB_POST_WithURL:REPOSTSTATUS WithPost:dic WithName:@"respot" WithSender:nil];
    [_loading show];
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    NSDictionary *dic = (NSDictionary *)data;
    NSArray *array = [dic allKeys];
    if (array.count > 0) {
        if ([self.delegates respondsToSelector:@selector(dismissSelf)]) {
            [_loading stop];
            [self.delegates dismissSelf];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

@end
