//
//  KWJCourseAlertView.m
//  Work01
//
//  Created by kwj on 14/11/24.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJCourseAlertView.h"

#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      264.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0

@interface KWJCourseAlertView()

@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic) NSArray *coursewareArray;

@property (nonatomic) BOOL cellSelected;

-(void)createBackgroundView;	// Draws and manages the view behind the alert
-(void)animateIn;	 // Animates the alert when it has to be shown
-(void)animateOut;	 // Animates the alert when it has to be dismissed
-(void)dismissTableAlert;	// Dismisses the alert

@end

@implementation KWJCourseAlertView

#pragma mark - MLTableAlert Class Method

+(KWJCourseAlertView *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle courseware:(NSArray *)coursewareArray delegate:(id)object{
    
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelBtnTitle courseware:coursewareArray delegate:object];
}

#pragma mark - MLTableAlert Initialization

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle courseware:(NSArray *)coursewareArray delegate:(id)object{
    self = [super init];
    if (self)
    {
        _coursewareArray = coursewareArray;
        _delegates = object;
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _height = kMinAlertHeight;	// Defining default (and minimum) alert height
    }
    
    return self;
}

#pragma mark - Actions

-(void)createBackgroundView
{
    // reset cellSelected value
    self.cellSelected = NO;
    
    // adding some styles to background view (behind table alert)
    //设置大小为全屏
    self.frame = [[UIScreen mainScreen] bounds];
    //设置 背景颜色  透明度
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    //不透明=NO    -》 透明
    self.opaque = NO;
    
    // adding it as subview of app's UIWindow
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self];
    
    // get background color darker
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    }];
}

//收回  警告框
-(void)animateIn
{
    // UIAlertView-like pop in animation
    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.alertBg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

//显示 警告框
-(void)animateOut
{
    [UIView animateWithDuration:1.0/7.5 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.3;
            } completion:^(BOOL finished){
                // table alert not shown anymore
                [self removeFromSuperview];
            }];
        }];
    }];
}

-(void)show
{
    [self createBackgroundView];
    
    // alert view creation
    //创建 警告view
    self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.alertBg];
    
    // setting alert background image
    //不需要背景
    //	UIImageView *alertBgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
    UIImageView *alertBgImage = [[UIImageView alloc] init];
    [self.alertBg addSubview:alertBgImage];
    
    // alert title creation
    //警告框 头部 title
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
    self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
    // 赋值
    self.titleLabel.text = self.title;
    //字体居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertBg addSubview:self.titleLabel];
    
    // table view creation
    //创建 tableview 设置为 无分组 类型
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //设置位置
    self.table.frame = CGRectMake(kLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - kCancelButtonMargin - kCancelButtonHeight);
    //圆角化
    self.table.layer.cornerRadius = 6.0;
    // 覆盖 下层 事物
    self.table.layer.masksToBounds = YES;
    //tableview 代理
    self.table.delegate = self;
    self.table.dataSource = self;
    // cell 选中样式
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableview 背景
    self.table.backgroundView = [[UIView alloc] init];
    [self.alertBg addSubview:self.table];
    
    // setting white-to-gray gradient as table view's background
    CAGradientLayer *tableGradient = [CAGradientLayer layer];
    tableGradient.frame = CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
    tableGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] CGColor], nil];
    [self.table.backgroundView.layer insertSublayer:tableGradient atIndex:0];
    
    // adding inner shadow mask on table view
    UIImageView *maskShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertShadowMask.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7]];
    maskShadow.userInteractionEnabled = NO;
    maskShadow.layer.masksToBounds = YES;
    maskShadow.layer.cornerRadius = 5.0;
    maskShadow.frame = self.table.frame;
    [self.alertBg addSubview:maskShadow];
    
    // cancel button creation
    //取消按钮 设置
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置 按钮 位置 大小
    self.cancelButton.frame = CGRectMake(kLateralInset, self.table.frame.origin.y + self.table.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
    //设置 按钮文字 居中
    self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置 按钮字体大小
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    //设置 按钮阴影
    self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //设置 按钮阴影颜色
    self.cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    //设置 文字
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    //设置 文字颜色
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //按钮 背景颜色 无色
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    //按钮 背景图片 正常 与 高亮
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
    //设置为 不透明
    self.cancelButton.opaque = NO;
    //按钮 圆角化
    self.cancelButton.layer.cornerRadius = 5.0;
    //绑定 事件
    [self.cancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBg addSubview:self.cancelButton];
    
    // setting alert and alert background image frames
    //设置 整体 背景
    //设置 整体 大小
    self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 2);
    alertBgImage.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, self.height);
    
    // the alert will be the first responder so any other controls,
    // like the keyboard, will be dismissed before the alert
    // 警报将成为第一个回答者所以任何其他控件,
    // 键盘一样,alertls之前将被解雇
    [self becomeFirstResponder];
    
    // show the alert with animation
    //显示 alert控件
    [self animateIn];
}

-(void)dismissTableAlert
{
    // dismiss the alert with its animation
    [self animateOut];
    
    // perform actions contained in completionBlock if the
    // cancel button of the alert has been pressed
    // if completionBlock == nil, nothing is performed
    //执行操作中包含completionBlock如果
    //取消按钮的警报被按下
    //如果completionBlock = =零,没有执行
    if (self.completionBlock != nil)
        if (!self.cellSelected)
            self.completionBlock();
}

// Allows the alert to be first responder
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

// Alert height setter
// 设置 alert 的高度
-(void)setHeight:(CGFloat)height
{
    if (height > kMinAlertHeight)
        _height = height;
    else
        _height = kMinAlertHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // TODO: Allow multiple sections
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // according to the numberOfRows block code
    //	return self.numberOfRows(section);
    return _coursewareArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"alertCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = ((Courseware *)_coursewareArray[indexPath.row]).title;
    //cell.detailTextLabel.text = @"213213";
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.cellSelected = YES;
    //选中某行后 执行代理
    [self dismissTableAlert];
    if ([self.delegates respondsToSelector:@selector(cellSeleted:couseware:)]) {
        [self.delegates cellSeleted:self couseware:_coursewareArray[indexPath.row]];
    }
    if ([self.delegates respondsToSelector:@selector(cellSeleted:couseware:index:)]) {
        [self.delegates cellSeleted:self couseware:_coursewareArray[indexPath.row] index:indexPath];
    }
    
}

@end
