//
//  PublishStatusController.m
//  Work01
//
//  Created by kwj on 14/12/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "PublishStatusController.h"
#import "KWJStatusTextView.h"
#import "KWJPublishToolView.h"
#import "Loading.h"
#import "KWJAccount.h"
#import "KWJAccountTool.h"
#import "HeaderFile.h"
#import "KWJPusblishPhotoView.h"
#import "UserFriendsTableViewController.h"
//#import "JSONKit.h"

#import "KWJLoading.h"

//第三方控件
#import "QBImagePickerController.h"

#define PUSHSTATUS @"https://api.weibo.com/2/statuses/update.json"
/*
 source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 status	        true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 visible	    false	int	    微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 list_id	    false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 lat	        false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 long	        false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 annotations	false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，      
                                具体内容可以自定。
 rip	        false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */

#define PUSHSTATUS_PHOTO @"https://upload.api.weibo.com/2/statuses/upload.json"
/*
 source	        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 status	        true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 visible	    false	int	    微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 list_id	    false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 pic	        true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
 lat	        false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 long	        false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 annotations	false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符， 
                                具体内容可以自定。
 rip	        false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */

@interface PublishStatusController ()<LoadBDConnectionDataDelegate,UIImagePickerControllerDelegate,userFriendsTableViewControllerDelegate,QBImagePickerControllerDelegate>

@property (nonatomic,weak) KWJStatusTextView *statusTextView;

@property (nonatomic,weak) KWJPublishToolView *toolView;

@property (nonatomic,weak) KWJPusblishPhotoView *photoView;

@property (nonatomic,weak) UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UIImagePickerController *mainImagePicker;

@property (nonatomic,strong) KWJLoading *sentStatus;

@end

@implementation PublishStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
//    self.mainImagePicker.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // textView 用导航 跳转过去 他会减去 64像素 也就是导航的高度 都是ScrollView 引起的 加上这句就没事了
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.sentStatus = [KWJLoading loadingWithTitle:@"正在发送。。。"];
    
    //导航栏 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitleColor:KWJColor(231, 231, 231) forState:UIControlStateNormal];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setEnabled:NO];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //导航栏 左按钮
    
    //加载 textview
    CGFloat textX = 10;
    CGFloat textY = 100;
    CGFloat textW = self.view.frame.size.width - 2 * textX;
    CGFloat textH = 150;
    KWJStatusTextView *statusTextView = [[KWJStatusTextView alloc] initWithRespot:@"分享学习感悟..." maxWord:140];
    statusTextView.frame = CGRectMake(textX, textY, textW, textH);
    //Block 判断是否可以发送
    statusTextView.notempty = ^(NSString *text){
        if (text.length > 0) {
            [self.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [self.rightBtn setEnabled:YES];
        }else{
            [self.rightBtn setTitleColor:KWJColor(231, 231, 231) forState:UIControlStateNormal];
            [self.rightBtn setEnabled:NO];
        }
    };
    [self.view addSubview:statusTextView];
    self.statusTextView = statusTextView;
    
    //加载图片预览控件
    KWJPusblishPhotoView *photoView = [[KWJPusblishPhotoView alloc] init];
    CGFloat photoX = 0;
    CGFloat photoH = 0;
    CGFloat photoY = CGRectGetMaxY(self.statusTextView.frame);
    CGFloat photoW = self.view.frame.size.width - 2 * photoX;
    photoView.frame = CGRectMake(photoX, photoY, photoW, photoH);
    [self.view addSubview:photoView];
    self.photoView = photoView;
    
    //加载下部工具条
    CGFloat toolX = 0;
    CGFloat toolH = 40;
    CGFloat toolY = self.view.frame.size.height - toolH;
    CGFloat toolW = self.view.frame.size.width - 2 * toolX;
    KWJPublishToolView *toolView = [[KWJPublishToolView alloc]initWith:^(UIButton *btn) {
        [self toolBtnCick:btn];
    }];
    toolView.frame = CGRectMake(toolX, toolY, toolW, toolH);
    [self.view addSubview:toolView];
    self.toolView = toolView;
    
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
        self.toolView.transform = CGAffineTransformMakeTranslation(0, transformY + 2);
    }];
}

- (void)dealloc
{
    //销毁 键盘 监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//工具条 按钮点击事件
-(void)toolBtnCick:(UIButton *)btn{
    if (btn.tag == 10001) {
        //图片
        //allowsMultipleSelection
//        [self presentViewController:self.mainImagePicker animated:YES completion:nil];
        
        //----------------------------
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
//        [imagePickerController release];
//        [navigationController release];
        //----------------------------
    }else if (btn.tag == 10002){
        //@
        UserFriendsTableViewController *friends = [[UserFriendsTableViewController alloc] init];
//        [self presentViewController:friends animated:YES completion:nil];
        friends.hidesBottomBarWhenPushed = YES;
        friends.delegates = self;
        [self.navigationController pushViewController:friends animated:YES];
    }else if (btn.tag == 10003){
        //#
        
    }
}

#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info{
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
//        NSLog(@"Selected %lu photos and mediaInfoArray==%@", (unsigned long)mediaInfoArray.count,mediaInfoArray);
//        NSLog(@"wwj");
        for (int i = 0; i < (int)mediaInfoArray.count; i++) {
            NSDictionary *dic = mediaInfoArray[i];
            UIImage *image = dic[UIImagePickerControllerOriginalImage];
            [self.photoView addPhoto:image];
        }
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        NSLog(@"Selected: %@", mediaInfo);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
//    NSLog(@"取消选择");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"%lu张图片", (unsigned long)numberOfPhotos];
}


//导航栏按钮事件
-(void)rightBtnClick:(UIButton *)snder{
    Loading *pushStatus = [Loading LoadDBWithDelegate:self];
    [self.view endEditing:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"access_token"] = [KWJAccountTool account].access_token;
    //要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
    dic[@"status"] = [[self.statusTextView getText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *mm=@[@{@"path":_xmlPath,@"name":_xmlName}];
    NSData *tempData=[NSJSONSerialization dataWithJSONObject:mm options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tempStr=[[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    dic[@"annotations"] =tempStr;
//    NSLog(@"%@",dic[@"annotations"]);
    
    if (self.photoView.photoArray.count == 1) {
        UIImage *photo = self.photoView.photoArray[0];
        //带一张图片
        dic[@"pic"] = UIImageJPEGRepresentation(photo, 0.7);
        [pushStatus LoadDB_POST_multipart_form_photo_WithURL:PUSHSTATUS_PHOTO WithPost:dic WithName:@"pushStatus" WithSender:nil];
    } else if (self.photoView.photoArray.count > 1){
        //带多张图片
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.photoView.photoArray.count; i++) {
            UIImage *photo = self.photoView.photoArray[i];
            [array addObject:UIImageJPEGRepresentation(photo, 0.7)];
        }
        dic[@"pic"] = array;
        [pushStatus LoadDB_POST_multipart_form_photos_WithURL:PUSHSTATUS_PHOTO WithPost:dic WithName:@"pushStatus" WithSender:nil];
    }else{
        //无图片
        [pushStatus LoadDB_POST_WithURL:PUSHSTATUS WithPost:dic WithName:@"pushStatus" WithSender:nil];
    }
    [self.sentStatus show];
}

-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    if ([name isEqualToString:@"pushStatus"]) {
        NSDictionary *dic = (NSDictionary *)data;
        if (dic[@"idstr"] != nil) {
            //发送成功
            [self.sentStatus stop];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

////相框代理
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    [self.photoView addPhoto:image];
//}
////- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//@好友页面 代理
-(void)returnSelectedFriends:(NSArray *)array{
//    NSLog(@"@");
    
    if (array.count > 0) {
        NSString *str = [self.statusTextView getText];
        NSString *temp = @"";
        for (int i = 0; i < array.count; i++) {
            temp = [NSString stringWithFormat:@"%@ @%@",temp,array[i]];
        }
        temp = [NSString stringWithFormat:@"%@%@ ",str,temp];
        [self.statusTextView setText:temp];
    }
    
    [self.navigationController popToViewController:self animated:YES];
}

@end
