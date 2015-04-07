//
//  LoginViewController.m
//  Work01
//
//  Created by kwj on 14/11/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "LoginViewController.h"
#import "KWJLoading.h"

#define LOGIN @"http://ccmc.sinaapp.com/User/login"

@interface LoginViewController ()

//联接数据库 查询数据
@property (nonatomic) Loading *load;
@property (nonatomic) KWJLoading *loading;

//界面点击事件
@property (nonatomic)UITapGestureRecognizer *viewTapGestureRecognizer;

//用户设置
@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化 界面点击事件
    _viewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick_Clicked)];
    [self.view addGestureRecognizer:_viewTapGestureRecognizer];
    
    //设置背景login_bg 
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //监听 其他页面回到此页面的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHere) name:@"quit"object:nil];
    
    //联接数据库 查询数据
    _load = [Loading LoadDBWithDelegate:self];
    
    //读取用户设置
    if (_defaults == nil) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    //用于清空 已有用户信息
//    [_defaults removeObjectForKey:@"counts"];
//    [_defaults removeObjectForKey:@"user"];
//    [_defaults removeObjectForKey:@"lastUser"];

    if ([_defaults valueForKey:@"counts"] == nil) {
        [_defaults setInteger:0 forKey:@"counts"];
        [_defaults setObject:[NSArray array] forKey:@"user"];
    }else if([_defaults integerForKey:@"counts"] > 0){
        NSDictionary *dic = [_defaults dictionaryForKey:@"lastUser"];
        //判断用户是否处在直接登录状态
        if (dic[@"isLogin"]) {
            //可以直接登录
            [self doLoginUserId:dic[@"userId"] Pwd:dic[@"pwd"]];
        }else{
            //只提供用户名，需要输入密码登录
            _nameTextField.text = dic[@"userId"];
        }
    }

}

-(void)backHere{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_defaults dictionaryForKey:@"lastUser"]];
    [dic setValue:false forKey:@"isLogin"];
    _nameTextField.text = dic[@"userId"];
    [_defaults setObject:dic forKey:@"lastUser"];
    
}

//界面 点击事件
-(void)viewClick_Clicked{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
//    self.view.window.backgroundColor = self.tableView.backgroundColor;
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY / 2);
    }];
}

- (void)dealloc
{
    //销毁 键盘 监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//数据查询 代理实现
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    //
    [_loading stop];
    NSArray *array = (NSArray *)data;
    if ([name isEqualToString:@"login"]) {
        if ([array[0] isEqualToString:@"success"]) {
            
            //添加用户到 用户 快速登录表
            NSMutableArray *array = [NSMutableArray arrayWithArray:[_defaults arrayForKey:@"user"]];
            //用户名 输入框 是否为空 来判断 是否是 手动输入账号登录，，如果是手动登录 && 此账号为第一次登录 进入 if
//            containsObject:     &&
            if (![_nameTextField.text isEqualToString:@""]) {
                //第一次 登陆的用户
                //设置已有用户总数
                if (![array containsObject:_nameTextField]) {
                    NSInteger count = [_defaults integerForKey:@"counts"];
                    count++;
                    [_defaults setInteger:count forKey:@"counts"];
                    //设置已有的 用户id
                    [array addObject:_nameTextField.text];
                    [_defaults setObject:array forKey:@"user"];
                }
                //设置当前 用户为 最后一次登录用户
                NSDictionary *dic = @{@"userId":_nameTextField.text,@"pwd":_pwdTextField.text,@"isLogin":@true};
                [_defaults setObject:dic forKey:@"lastUser"];
                
                //最终保存数据
                [_defaults synchronize];
            }
            
            //清空连个 textField
            _nameTextField.text = @"";
            _pwdTextField.text = @"";
            
            //登陆成功
            [self performSegueWithIdentifier:@"login" sender:nil];
        }else if([array[0] isEqualToString:@"failed"]){
            //登陆失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"找回密码", nil];
            [alert show];
        }
    }
}

- (void)doLoginUserId:(NSString *)userId Pwd:(NSString *)pwd{
    //请求数据
    NSDictionary *dic = @{@"userId":userId,@"password":pwd};
    [_load LoadDB_POST_WithURL:LOGIN WithPost:dic WithName:@"login" WithSender:nil];
    
    //登陆过度页面
    _loading = [KWJLoading loadingWithTitle:@"Loading..."];
    [_loading show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"register"]) {
        [segue.destinationViewController setDelegates:self];
    }
}

//登陆按钮
- (IBAction)loginButton_Click:(id)sender {
    //键盘缩回
    [self.view endEditing:YES];
    
    //登陆
    NSString *userId = _nameTextField.text;
    NSString *pwd = _pwdTextField.text;
    [self doLoginUserId:userId Pwd:pwd];
}

//找回密码按钮
- (IBAction)findPwdButton_Click:(id)sender {
}

//注册按钮
- (IBAction)registerButton_Click:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:nil];
}

//注册完成后执行代理
-(void)gotLoginUserId:(NSString *)userId pwd:(NSString *)pwd{
    //用户注册完成
    //直接登陆
    _nameTextField.text = userId;
    _pwdTextField.text = pwd;
    [self doLoginUserId:userId Pwd:pwd];
}

//屏幕点击事件
- (IBAction)viewClick_Click:(id)sender {
    [self.view endEditing:YES];
}

@end
