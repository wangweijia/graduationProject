//
//  TopTool.m
//  Work01
//
//  Created by kwj on 14/12/11.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "TopTool.h"
#import "UIImage+KWJ.h"
#import "KWJStatus.h"

@interface TopTool()

@property (nonatomic, weak) UIButton *reweetBtn;//转发
@property (nonatomic, weak) UIButton *commentBtn;//评论
@property (nonatomic, weak) UIButton *attitudeBtn;//赞

@property (nonatomic, weak) UIImageView *divider;

@end

@implementation TopTool

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        //背景
        self.image = [UIImage resizedImageWithName:@"cell_comment_tool_bg" left:0.9 top:0.1];
        
        // 添加按钮
        //reweetBtn;//转发
        self.reweetBtn = [self setupBtnWithTitle:@"转发" image:@"timeline_icon_retweet" bgImage:@"timeline_card_leftbottom_highlighted" action:@selector(toolButtons_Click:)];
        self.reweetBtn.tag = 10001;
        
        //commentBtn;//评论
        self.commentBtn = [self setupBtnWithTitle:@"评论" image:@"timeline_icon_comment" bgImage:@"timeline_card_middlebottom_highlighted" action:@selector(toolButtons_Click:)];
        self.commentBtn.tag = 10002;
        
        //attitudeBtn;//赞
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" image:@"timeline_icon_unlike" bgImage:@"timeline_card_rightbottom_highlighted" action:@selector(attitudeBtn_Click:)];
        self.attitudeBtn.tag = 10003;
        
        //添加分割线
        self.divider = [self setupDivider];
//        self.divider.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)selectBtn:(NSInteger)tag{
    if (tag == 10001) {
        self.selectBtn = self.reweetBtn;
    }else if (tag == 10002){
        self.selectBtn = self.commentBtn;
    }
    [self.selectBtn setBackgroundImage:[UIImage resizedImageWithName:@"cell_comment_but_bg" left:0.9 top:0.1] forState:UIControlStateNormal];
}

/*
 *  初始化按钮
 *
 *  @param title   按钮的文字
 *  @param image   按钮的小图片
 *  @param bgImage 按钮的背景
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title image:(NSString *)image bgImage:(NSString *)bgImage action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    //设置图片
    [btn setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    //设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    //标题颜色
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //标题字体
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    //图片 边距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    //图片没有高亮
    btn.adjustsImageWhenHighlighted = NO;
    //添加点击事件
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //设置背景
//    [btn setBackgroundImage:[UIImage resizedImageWithName:bgImage] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage resizedImageWithName:@"cell_comment_but_bg" left:0.9 top:0.1] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    return btn;
}

/*
 *  添加分割线
 */
-(UIImageView *)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"cell_comment_divi_bg"];
    [self addSubview:divider];
    return divider;
}

// 拦截 数据加载
-(void)setStatus:(KWJStatus *)status{
    _status = status;
    
    [self setupBtn:_reweetBtn originalTitle:@"转发" count:_status.reposts_count];
    [self setupBtn:_commentBtn originalTitle:@"评论" count:_status.comments_count];
    [self setupBtn:_attitudeBtn originalTitle:@"赞" count:_status.attitudes_count];
}


/*
 *  显示时加载
 */
-(void)layoutSubviews{
    
    [super layoutSubviews];

    //按钮宽度
    CGFloat btnW = 60;
    
    //reweetBtn;//转发
    CGFloat reweetX = 0;
    CGFloat reweetY = 0;
    CGFloat reweetW = btnW;
    CGFloat reweetH = self.frame.size.height;
    _reweetBtn.frame = CGRectMake(reweetX, reweetY, reweetW, reweetH);
    
    //commentBtn;//评论
    CGFloat commentX = CGRectGetMaxX(_reweetBtn.frame) + 2;
    CGFloat commentY = 0;
    CGFloat commentW = btnW;
    CGFloat commentH = self.frame.size.height;
    _commentBtn.frame = CGRectMake(commentX, commentY, commentW, commentH);
    
    //attitudeBtn;//赞
    CGFloat attitudeX = self.frame.size.width - btnW - 5;
    CGFloat attitudeY = 0;
    CGFloat attitudeW = btnW;
    CGFloat attitudeH = self.frame.size.height;
    _attitudeBtn.frame = CGRectMake(attitudeX, attitudeY, attitudeW, attitudeH);
    
    //分割线
    CGFloat diviX = CGRectGetMaxX(_reweetBtn.frame);
    CGFloat diviY = 0;
    CGFloat diviH = reweetH;
    CGFloat diviW = 2;
    _divider.frame = CGRectMake(diviX, diviY, diviW, diviH);
}

// 转发 与 评论 按钮点击事件
-(void)toolButtons_Click:(UIButton *)sender{
    UIButton * btn = sender;
    [self.selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    //设置背景
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"cell_comment_but_bg" left:0.9 top:0.1] forState:UIControlStateNormal];
    //设置选中 按钮
    self.selectBtn = btn;
    
    if ([self.delegates respondsToSelector:@selector(toolBtnClicked:)]) {
        [self.delegates toolBtnClicked:btn];
    }
}

//赞 点击事件
-(void)attitudeBtn_Click:(UIButton *)sender{
    UIButton *btn = sender;
    if ([self.delegates respondsToSelector:@selector(toolBtnClicked:)]) {
        [self.delegates toolBtnClicked:btn];
    }
}

- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count
{
    /*
     0 -> @"转发"
     <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
     >= 10000
     * 整万(10100, 20326, 30000 ....) : 1万, 2万
     * 其他(14364) : 1.4万
     */
    
    if (count) { // 个数不为0
        NSString *title = nil;
        if (count < 10000) { // 小于1W
            title = [NSString stringWithFormat:@"%d", count];
        } else { // >= 1W
            // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
            // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
            // double countDouble = count / 1000 * 0.1;
            
            // 42342 / 10000.0 = 4.2342
            // 10742 / 10000.0 = 1.0742
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            // title == 4.2万 4.0万 1.0万 1.1万
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

@end
