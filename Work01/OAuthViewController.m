//
//  OAuthViewController.m
//  Work01
//
//  Created by kwj on 14/12/3.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "OAuthViewController.h"
#import "Loading.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"
#import "KWJLoading.h"
#import "IWTabBarViewController.h"

#define OAuthURL @"https://api.weibo.com/oauth2/authorize?client_id=506191744&redirect_uri=http://www.baidu.com"
#define TOKENURL @"https://api.weibo.com/oauth2/access_token"


@interface OAuthViewController ()<LoadBDConnectionDataDelegate,UIWebViewDelegate>

@property (nonatomic) KWJLoading *load;

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:OAuthURL];
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
/*
 *  开始加载页面
 */
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _load = [KWJLoading loadingWithTitle:@"加载中。。。"];
    [_load show];
}

/*
 *  页面加载完成
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_load stop];
}

/*
 *  当webview 发送一个请求时先调用
 *
 *  @param webView        当前控件
 *  @param request        请求
 *  @param navigationType
 *
 *  @return yes 允许显示
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlStr = request.URL.absoluteString;
    
    NSRange range = [urlStr rangeOfString:@"code="];
    
    if (range.length > 0) {
        int loc = (int)range.location + (int)range.length;
        NSString *code = [urlStr substringFromIndex:loc];
        
        Loading *load = [Loading LoadDBWithDelegate:self];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"client_id"] = @"506191744";
        params[@"client_secret"] = @"795cabfb59f8ede5a5e0a004a36e7a37";
        params[@"grant_type"] = @"authorization_code";
        params[@"code"] = code;
        params[@"redirect_uri"] = @"http://www.baidu.com";
        
        
        [load LoadDB_POST_WithURL:TOKENURL WithPost:params WithName:@"token" WithSender:nil];
        
        //不需要返回接下来得 页面
        return NO;
    }
    
    //通过 code 获得用户 访问方式

    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"token"]) {
        NSDictionary *dic = (NSDictionary *)data;
        
        KWJAccount *account = [KWJAccount accountWithDict:dic];

        
        //存储模型数据
        [KWJAccountTool saveAccount:account];
        
//        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.view.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"tabbar"];
        self.view.window.rootViewController = [[IWTabBarViewController alloc] init];
    }
}

@end
