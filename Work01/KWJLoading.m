//
//  KWJLaoding.m
//  Work01
//
//  Created by kwj on 14/11/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJLoading.h"

#define BgWidth            200.0
#define LateralInset       12.0 //label

@interface KWJLoading()

@property (nonatomic, strong) UIView *loadBg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activity;
@property (nonatomic) NSTimer *timer;
@property (nonatomic,strong) id parentController;

@end

@implementation KWJLoading

+(KWJLoading *)loadingWithTitle:(NSString *)title{
    KWJLoading *load = [[KWJLoading alloc]initWithTitle:title];
    
    return load;
}

+(KWJLoading *)loadingWithTitle:(NSString *)title ParentController:(id)object{
    KWJLoading *load = [[KWJLoading alloc]initWithTitle:title parentController:object];
    
    return load;
}

-(id)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        _title = title;
    }
    
    return self;
}

-(id)initWithTitle:(NSString *)title parentController:(id)object{
    if (self = [super init]) {
        _title = title;
        _parentController = object;
    }
    
    return self;
}

-(void)createBackgroundView{
    
    // adding some styles to background view (behind table alert)
    //设置大小为全屏
    self.frame = [[UIScreen mainScreen] bounds];
    //设置 背景颜色  透明度
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    //不透明=NO    -》 透明
    self.opaque = NO;
    
    // adding it as subview of app's UIWindow
    if (_parentController == nil) {
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        [appWindow addSubview:self];
    }else{
        [_parentController addSubview:self];
        self.frame = [[UIScreen mainScreen] bounds];
//        self.frame = CGRectMake(0, 50, 300, 400);
    }
    
    
    // get background color darker
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    }];
}

//启动32秒后自动关闭
-(void)timerFired:(NSTimer *)timer{
    
    self.titleLabel.text = @"网络请求超时";
    self.activity.hidden = YES;
//    if (self.loadOutTime != nil) {
//        self.loadOutTime();
//    }
    if (self.outTime != nil) {
        self.outTime();
    }
    [self performSelector:@selector(stop) withObject:nil afterDelay:2.0];
//    [self stop];
}

-(void)animateIn{
    // UIAlertView-like pop in animation
    self.loadBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        self.loadBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.loadBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.loadBg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:32.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

-(void)animateOut{
    [UIView animateWithDuration:1.0/7.5 animations:^{
        self.loadBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.loadBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.loadBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.3;
            } completion:^(BOOL finished){
                // table alert not shown anymore
                [self removeFromSuperview];
            }];
        }];
    }];
    
    [_timer invalidate];
}

-(void)show{
    [self createBackgroundView];
    
    self.loadBg = [[UIView alloc] initWithFrame:CGRectZero];
    self.loadBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.loadBg.layer.cornerRadius = 5;
    
    [self addSubview:self.loadBg];
    
    
    //其他控件 都放在self.alertBg
    
    //加载框 头部 title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //背景 颜色 无色
    self.titleLabel.backgroundColor = [UIColor clearColor];
    //字体 颜色 白色
    self.titleLabel.textColor = [UIColor whiteColor];
    //阴影 颜色 透明度
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    //阴影 透明度
    self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //字体 设置
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    //大小 位置 设置
    self.titleLabel.frame = CGRectMake(LateralInset, 15, BgWidth - LateralInset * 2, 22);
    // 赋值
    self.titleLabel.text = self.title;
    //字体居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loadBg addSubview:self.titleLabel];
    
    
    //加载框 转动控件
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activity.frame = CGRectMake(BgWidth/2, 60 , 0, 0);
    activity.hidden = NO;
    _activity = activity;
    [self.loadBg addSubview:activity];
    [_activity startAnimating];
    
    // setting alert and alert background image frames
    //设置 整体 背景
    //设置 整体 大小
    self.loadBg.frame = CGRectMake((self.frame.size.width - BgWidth) / 2, self.frame.size.height / 2, BgWidth, 100);
    
    // the alert will be the first responder so any other controls,
    // like the keyboard, will be dismissed before the alert
    // 警报将成为第一个回答者所以任何其他控件,
    // 键盘一样,alertls之前将被解雇
    [self becomeFirstResponder];
    
    [self animateIn];
}

-(void)stop{
    [self animateOut];
}


@end
