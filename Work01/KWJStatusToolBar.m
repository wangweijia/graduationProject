//
//  KWJStatusToolBar.m
//  Work01
//
//  Created by kwj on 14/12/5.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusToolBar.h"
#import "KWJStatus.h"
#import "UIImage+KWJ.h"

@interface KWJStatusToolBar()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *reweetBtn;//转发
@property (nonatomic, weak) UIButton *commentBtn;//评论
@property (nonatomic, weak) UIButton *attitudeBtn;//评论课程

@end

@implementation KWJStatusToolBar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;//用户可操作
        self.image = [UIImage resizedImageWithName:@"timeline_card_bottom_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_bottom_background_highlighted"];
        
        // 添加按钮
        self.reweetBtn = [self setupBtnWithTitle:@"转发" image:@"timeline_icon_retweet" bgImage:@"timeline_card_leftbottom_highlighted"];
        self.reweetBtn.tag = 10001;
        
        self.commentBtn = [self setupBtnWithTitle:@"评论" image:@"timeline_icon_comment" bgImage:@"timeline_card_middlebottom_highlighted"];
        self.commentBtn.tag = 10002;
        
        self.attitudeBtn = [self setupBtnWithTitle:@"课程" image:@"timeline_icon_unlike" bgImage:@"timeline_card_rightbottom_highlighted"];
        self.attitudeBtn.tag = 10003;
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

/*
 *  初始化按钮
 *
 *  @param title   按钮的文字
 *  @param image   按钮的小图片
 *  @param bgImage 按钮的背景
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title image:(NSString *)image bgImage:(NSString *)bgImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.adjustsImageWhenHighlighted = NO;
    //添加点击事件
    [btn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:[UIImage resizedImageWithName:bgImage] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    
    // 添加按钮到数组
    [self.btns addObject:btn];
    
    return btn;
}

/*
 *  添加分割线
 */
-(void)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    int dividerCount = (int)self.dividers.count; // 分割线的个数
    CGFloat dividerW = 2; // 分割线的宽度
    int btnCount = (int)self.btns.count;
    
    CGFloat btnW = (self.frame.size.width - dividerW * dividerCount) / btnCount;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    //按钮
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.btns[i];
        CGFloat btnX = i * (btnW + dividerW);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    CGFloat dividerH = btnH;
    CGFloat dividerY = 0;
    //分割线
    for (int i = 0; i < dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        
        CGFloat dividerX = (i + 1) * btnW + i * dividerW;
        
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
    
    //如果没有课件   就让按钮不可点击
    if (_status.xmlPath == nil) {
        self.attitudeBtn.enabled = NO;
    }else{
        self.attitudeBtn.enabled = YES;
    }
}

-(void)setStatus:(KWJStatus *)status{
    _status = status;
    // 1.设置转发数
    [self setupBtn:self.reweetBtn originalTitle:@"转发" count:status.reposts_count];
    [self setupBtn:self.commentBtn originalTitle:@"评论" count:status.comments_count];
//    [self setupBtn:self.attitudeBtn originalTitle:@"课程" count:status.attitudes_count];
}

/*
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮需要设置标题
 *  @param originalTitle 按钮的原始标题(显示的数字为0的时候, 显示这个原始标题)
 *  @param count         显示的个数
 */
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
        } else { //
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

//代理
-(void)toolBtnClicked:(UIButton *)sender{
    if ([self.delegates respondsToSelector:@selector(toolBarBtnClick:status:)]) {
        [self.delegates toolBarBtnClick:sender status:_status];
    }
}
@end
