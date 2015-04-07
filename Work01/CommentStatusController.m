//
//  CommentStatusController.m
//  Work01
//
//  Created by kwj on 14/12/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "CommentStatusController.h"
#import "KWJStatusTextView.h"
#import "Loading.h"
#import "HeaderFile.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"

#define COMMENT @"https://api.weibo.com/2/comments/create.json"
/*
source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
comment	        true	string	评论内容，必须做URLencode，内容不超过140个汉字。
id	            true	int64	需要评论的微博ID。
comment_ori	    false	int	    当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
rip	            false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */

@interface CommentStatusController ()<LoadBDConnectionDataDelegate>

@property (nonatomic,weak)KWJStatusTextView *textView;

@property (nonatomic,weak)UIButton *rightBtn;

@property (nonatomic,strong)Loading *commentLoad;

@end

@implementation CommentStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // textView 用导航 跳转过去 他会减去 64像素 也就是导航的高度 都是ScrollView 引起的 加上这句就没事了
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitleColor:KWJColor(231, 231, 231) forState:UIControlStateNormal];
    [rightBtn setTitle:@"评论" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setEnabled:NO];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //加载 textview
    CGFloat textX = 10;
    CGFloat textY = 100;
    CGFloat textW = self.view.frame.size.width - 2 * textX;
    CGFloat textH = 150;
    KWJStatusTextView *textView = [[KWJStatusTextView alloc] initWithRespot:@"发表感想！" maxWord:140];
    textView.frame = CGRectMake(textX, textY, textW, textH);
    //Block 判断是否可以发送
    textView.notempty = ^(NSString *text){
        if (text.length > 0) {
            [self.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [self.rightBtn setEnabled:YES];
        }else{
            [self.rightBtn setTitleColor:KWJColor(231, 231, 231) forState:UIControlStateNormal];
            [self.rightBtn setEnabled:NO];
        }
    };
    [self.view addSubview:textView];
    self.textView = textView;
}

//导航栏右边按钮点击
-(void)rightBtnClick:(UIButton *)sender{
    _commentLoad = [Loading LoadDBWithDelegate:self];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    dic[@"comment"] = [[self.textView getText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dic[@"id"] = _statusId;
    [_commentLoad LoadDB_POST_WithURL:COMMENT WithPost:dic WithName:@"commentStatus" WithSender:nil];
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"commentStatus"]) {
        NSDictionary *dc = (NSDictionary *)data;
        if (dc[@"id"] != nil) {
            //评论成功
            if ([self.delegates respondsToSelector:@selector(dismissSelf)]) {
                [self.delegates dismissSelf];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
