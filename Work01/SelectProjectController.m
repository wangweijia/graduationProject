//
//  SelectProjectController.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SelectProjectController.h"
#import "Project.h"//数据模型
#import "Course.h" //数据模型
#import "KWJHeaderView.h"
#import "SelectCourseController.h"
#import "KWJLoading.h"

//收藏课程
//#import "KWJCollectCourse.h"
#import "KWJHandleSQL.h"

#import "KWJAccount.h"
#import "KWJAccountTool.h"

#import "AppDelegate.h"

//得到学习领域
#define TYPE @"http://ccmc.sinaapp.com/Course/getCourseType"
//得到各领域课程
#define COURSE @"http://ccmc.sinaapp.com/Course/getCourseList"

@interface SelectProjectController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,weak) UIButton *refreshBtn;
@property (nonatomic,strong) NSArray *project;//提供学习的领域 数据
@property (nonatomic,strong) Loading *loads;//用于数据请求

@property (nonatomic,strong) KWJHandleSQL *collect;

@property (nonatomic) KWJLoading *loading;

@end

@implementation SelectProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableview 样式设置
    self.mainTableView.rowHeight=60;
    self.mainTableView.sectionHeaderHeight=44;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除cell的分隔线
    //联接数据库 查询数据
    _loads = [Loading LoadDBWithDelegate:self];

    //数据请求不成再次请求
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat BtnW = 150;
    CGFloat BtnH = 60;
    CGFloat BtnX = (self.view.bounds.size.width - BtnW) / 2;
    CGFloat BtnY = (self.view.bounds.size.height - BtnH) / 2 * 0.7;
    refreshBtn.frame = CGRectMake(BtnX, BtnY, BtnW, BtnH);
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.hidden = YES;
    [self.mainTableView addSubview:refreshBtn];
    self.refreshBtn = refreshBtn;
    
    //数据库的名字是 dbzk
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    KWJHandleSQL *collect = [[KWJHandleSQL alloc] initDBName:@"dbzk.sqlite"];
    self.collect = appDelegate.mySQL;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"]         = @"text";
    dic[@"userId"]       = @"text";
    dic[@"courseId"]     = @"text";
    dic[@"teacherName"]  = @"text";
    dic[@"access_token"] = @"text";
    [self.collect creatTabel:@"t_collect" key:dic];
    
    //加载数据
    [self loadData];
}

/*
 *  每次显示页面都调用此函数，刷新数据
 *
 *  @param animated animated description
 */
-(void)viewWillAppear:(BOOL)animated{
    [self.mainTableView reloadData];
}

/*
 @property (nonatomic,copy) NSString *name;
 @property (nonatomic,copy) NSString *userId;
 @property (nonatomic,copy) NSString *teacherName;
 @property (nonatomic) int mark;
 @property (nonatomic,copy) NSString *courseId;
 */

-(void)loadData{
    NSString *url =TYPE;
    [_loads LoadDB_GET_WithURL:url WithName:@"getArray" WithSender:nil];
//    _loading = [KWJLoading loadingWithTitle:@"正在请求数据..."];
    _loading = [KWJLoading loadingWithTitle:@"正在请求数据..." ParentController:self.mainTableView];
    
    [_loading show];
//    _loading.loadOutTime = ^(void){
//        self.refreshBtn.hidden = NO;
//    };
    //防止block循环调用
    __block SelectProjectController *selectProjectContriller = self;
    _loading.outTime = ^(void){
        selectProjectContriller.refreshBtn.hidden = NO;
    };
}

-(void)refreshBtnClick:(UIButton *)sender{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate方法 访问数据库 成功 得到数据后调用
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender{
    //找到与之匹配的返回结果，执行相应操作
    
    NSArray *array = (NSArray *)data;
    if ([name  isEqual: @"getArray"]) {
//        NSLog(@"getArray");
        [_loading stop];
        _refreshBtn.hidden = YES;
        _project=[self project:array];
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }else if ([name isEqualToString:@"getCourse"]){
//        NSLog(@"getCourse");
        
        Project *pro = _project[[sender integerValue]];
        for (int i = 0; i < array.count; i++) {
            [pro setCourseByDictionary:(NSDictionary *)array[i]];
        }
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }else if ([name isEqualToString:@"nextCourse"]){
//        NSLog(@"nextCourse");
        
        Project *pro = _project[[sender integerValue]];
        for (int i = 0; i < array.count; i++) {
            [pro setCourseByDictionary:(NSDictionary *)array[i]];
        }
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }
    
}

//初始化 project 数据模型
-(NSArray *)project:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Project *pro = [Project projectWithDict:dic];
        [tempArray addObject:pro];
    }
    return tempArray;
}

/*
 *  当头部被点击的时候 delegate 回调
 */
- (void)headerViewDidClickedNameView:(KWJHeaderView *)headerView{
    //刷新数据
    [self.mainTableView reloadData];
}

/*
 *  table view 传递数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _project.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Project *pro = _project[section];
    //如果是展开 就 获取数据  并且只获取一次
    if (pro.isOpened && pro.course.count == 0 && pro.count > 0) {
        
        NSString *url =[NSString stringWithFormat:@"%@?courseType=%d&page=%d",COURSE,pro.typeId,1];
        pro.page = 1;
        [_loads LoadDB_GET_WithURL:url WithName:@"getCourse" WithSender:[NSNumber numberWithInteger:section]];
    }
    
    return (pro.isOpened ? pro.course.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseCell *cell = [CourseCell cellWithTableView:tableView];
    cell.delegates = self;
    Project *pro = _project[indexPath.section];
    [cell setCourse:(Course *)pro.course[indexPath.row]];
    
//    NSLog(@"%ld,%ld",(long)indexPath.row,pro.maxRow);
    
    if (pro.course.count-5 <= indexPath.row && pro.page*10 < pro.count) {
        
        //每次 内容 读取 5条时  && 当前cell条数 小于 该项目cell总数时
        pro.page++;
        NSString *url =[NSString stringWithFormat:@"%@?courseType=%d&page=%d",COURSE,pro.typeId,pro.page];
        [_loads LoadDB_GET_WithURL:url WithName:@"nextCourse" WithSender:[NSNumber numberWithInteger:indexPath.section]];
    }
    cell.isCollect = [self isCollectCourse:(Course *)pro.course[indexPath.row]];
    return cell;
}

//加载头部空间
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //创建头部控件
    KWJHeaderView *header =[KWJHeaderView headerViewWithTableView:tableView];
    //头部控件赋值
    header.delegates=self;
    header.project=_project[section];
    
    return header;
}

-(BOOL)isCollectCourse:(Course *)course{
    //查询
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
    dic3[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
    dic3[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
    dic3[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
    dic3[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
    if ([_collect selectTabel:@"t_collect" value:@[@" * "] where:dic3] == nil) {
        return NO;
    }else{
        return YES;
    }
}

//课程 收藏按钮 点击触发代理时事件
- (void)collectButtonClick:(Course *)course{

    if (![self isCollectCourse:course]) {
        //插入
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
        dic1[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
        dic1[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
        dic1[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
        dic1[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
        [_collect insertInto:@"t_collect" value:dic1];
    }else{
        //删除
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[@"name"]         = [NSString stringWithFormat:@"'%@'",course.name];
        dic2[@"userId"]       = [NSString stringWithFormat:@"'%@'",course.userId];
        dic2[@"courseId"]     = [NSString stringWithFormat:@"'%@'",course.courseId];
        dic2[@"teacherName"]  = [NSString stringWithFormat:@"'%@'",course.teacherName];
        dic2[@"access_token"] = [NSString stringWithFormat:@"'%@'",[KWJAccountTool account].access_token];
        [_collect deletesFrom:@"t_collect" where:dic2];
    }
}
/*
 //插入
 NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
 [_collect insertData:@"t_collect" value:dic1];
 
 //查询
 NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
 [_collect select:@"t_collect" value:@[@"*"] where:dic3];
 
 //删除
 NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
 [_collect deletes:@"t_collect" where:dic2];
 */

//cell  选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Project *pro = _project[indexPath.section];
//    NSString *path = ((Course *)pro.course[indexPath.row]).courseId;
//    NSString *name = ((Course *)pro.course[indexPath.row]).name;
//    NSLog(@"xmlPath:%@",path);
    [self performSegueWithIdentifier:@"course" sender:pro.course[indexPath.row]];
}

//页面跳转事件
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"course"]) {
        NSString *courseId = ((Course *)sender).courseId;
        NSString *courseName = ((Course *)sender).name;
        [[segue destinationViewController] setCourseId:courseId];
        [[segue destinationViewController] setCourseName:courseName];
    }
}

/*
 *设置每一个头部控件的高度
 */
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

@end
