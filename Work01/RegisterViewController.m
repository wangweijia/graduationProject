//
//  RegisterViewController.m
//  Work01
//
//  Created by kwj on 14/11/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "RegisterViewController.h"

//检测用户名 是否可用 接口
#define DETECTION_USERID @"http://ccmc.sinaapp.com/User/checkUserId"
//注册 接口
#define REGISTER @"http://ccmc.sinaapp.com/User/regist"

@interface RegisterViewController ()

@property (nonatomic) Loading *load;

//3个注册必要条件
@property (nonatomic) BOOL userIdOk;
@property (nonatomic) BOOL pwdOk;
@property (nonatomic) BOOL pwdAgainOk;

//用户名
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
//密码确认
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTextField;

//用户名情况 提示框
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
//密码情况 提示框
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
//密码确认情况 提示框
@property (weak, nonatomic) IBOutlet UILabel *pwdAgainLabel;

//用户名检测提示
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *userIdActivityView;

//view 点击事件
@property (nonatomic) UITapGestureRecognizer *viewTapGestureRecognizer;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载点击事件
    _viewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick_Clicked)];
    [self.view addGestureRecognizer:_viewTapGestureRecognizer];
    
    //Label 内容为空
    _userIdLabel.text = @"只能包含大小写字母和数字长度限制为6-18位";
    _userIdLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _pwdLabel.text = @"不能包含@符号，长度限制为6-18位";
    _pwdLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _pwdAgainLabel.text = @"两次密码要一致";
    _pwdAgainLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    //隐藏加载框
    _userIdActivityView.hidden = YES;
    
    //初始化 数据请求类
    _load = [Loading LoadDBWithDelegate:self];
    
    //初始化 注册 必要条件
    _userIdOk = false;
    _pwdOk = false;
    _pwdAgainOk = false;
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//界面点击事件
-(void)viewClick_Clicked{
    [self.view endEditing:YES];
}

//数据请求 代理
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
//    NSLog(@"%@",array);
    NSArray *array = (NSArray *)data;
    if ([name isEqualToString:@"detectionUserId"]) {
        //关闭加载动画
        [_userIdActivityView stopAnimating];
        _userIdActivityView.hidden = YES;
        
        _userIdOk = false;
        if ([array[0] isEqualToString:@"ok"]) {
            _userIdLabel.text = @"用户名可用";
            _userIdLabel.textColor = [UIColor greenColor];
            _userIdOk = true;
        }else if ([array[0] isEqualToString:@"exist"]){
            _userIdLabel.text = @"用户ID已存在";
            _userIdLabel.textColor = [UIColor redColor];
        }else if ([array[0] isEqualToString:@"wrong"]){
            _userIdLabel.text = @"用户ID不合法";
            _userIdLabel.textColor = [UIColor redColor];
        }
    }else if ([name isEqualToString:@"register"]){
        if ([array[0] isEqualToString:@"success"]) {
            //注册成功
            // 成功提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功\n即将为您登陆" delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            //关闭 alert 同时执行关闭当前页面，执行登陆
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
        }else if ([array[0] isEqualToString:@"failed"]) {
            //注册失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器异常\n注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

//用户名输入完成
- (IBAction)userIdTextField_EditEnd:(id)sender {
    if (![_userIdTextField.text isEqualToString:@""]) {
        NSString *url = [NSString stringWithFormat:@"%@?userId=%@",DETECTION_USERID,_userIdTextField.text];
        [_load LoadDB_GET_WithURL:url WithName:@"detectionUserId" WithSender:nil];
        
        //开启用户名检测 activityview 控件
        _userIdActivityView.hidden = NO;
        [_userIdActivityView startAnimating];
    }
}
//密码输入完成
- (IBAction)pwdTextField_EnditEnd:(id)sender {
    _pwdOk = false;
    NSString *pwd = _pwdTextField.text;
    if (pwd.length > 18 || pwd.length < 6) {
        _pwdLabel.text = @"长度限制为6-18位";
        _pwdLabel.textColor = [UIColor redColor];
    }else if ([pwd rangeOfString:@"@"].location != NSNotFound) {
        _pwdLabel.text = @"不能包含@符号";
        _pwdLabel.textColor = [UIColor redColor];
    }else{
        _pwdLabel.text = @"密码可用";
        _pwdLabel.textColor = [UIColor greenColor];
        _pwdOk = true;
    }
}
//密码确认 输入完成
- (IBAction)pwdAgainTextField_EnditEnd:(id)sender {
    _pwdAgainOk = false;
    if ([_pwdTextField.text isEqualToString:_pwdAgainTextField.text]) {
        _pwdAgainLabel.text = @"两次密码一致";
        _pwdAgainLabel.textColor = [UIColor greenColor];
        _pwdAgainOk = true;
    }else{
        _pwdAgainLabel.text = @"两次密码不一致";
        _pwdAgainLabel.textColor = [UIColor redColor];
    }
}

//注册按钮点击
- (IBAction)registerButton_Click:(id)sender {
    //键盘缩回
    [self.view endEditing:YES];
    
    if (_userIdOk && _pwdOk && _pwdAgainOk) {
        NSDictionary *dic = @{@"userId":_userIdTextField.text,@"password":_pwdTextField.text};
        [_load LoadDB_POST_WithURL:REGISTER WithPost:dic WithName:@"register" WithSender:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"注册信息不正确\n请查看各项提示" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//键盘 活动 事件
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

//关闭 alert 同时执行关闭当前页面，执行登陆   用于延迟关闭
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    
    //关闭当前页面
    [self dismissViewControllerAnimated:YES completion:^(void){
        //让登陆界面登陆  代理事件
        if ([self.delegates respondsToSelector:@selector(gotLoginUserId:pwd:)]) {
            [self.delegates gotLoginUserId:_userIdTextField.text pwd:_pwdTextField.text];
        }
    }];
}

@end
