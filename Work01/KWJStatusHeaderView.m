//
//  KWJStatusHeaderView.m
//  Work01
//
//  Created by kwj on 14/12/12.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusHeaderView.h"
#import "UIImage+KWJ.h"

@interface KWJStatusHeaderView()

@property (nonatomic,weak) TopTool *topTool;

@property (nonatomic,weak) BottomTool *bottomTool;

@end

@implementation KWJStatusHeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    //创建头部控件
    static NSString *ID = @"headtool";
    KWJStatusHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (header == nil) {
        header = [[KWJStatusHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    return header;
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView topToolDelegate:(id)object{
    static NSString *ID = @"headtool";
    KWJStatusHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[KWJStatusHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    header.topTool.delegates = object;
    header.bottomTool.delegates = object;
    return header;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
      
        [self setupView];
    }
    return self;
}

//设置 选中 按钮
- (void)setSelectBtn:(NSInteger)tag{
    [self.topTool selectBtn:tag];
}

// 拦截 数据源的获得
-(void)setStatus:(KWJStatus *)status{
    _status =status;
    
    if (_status.comments_count > 0) {
        self.bottomTool.hidden = YES;
    }else{
        self.bottomTool.hidden = NO;
    }
    
    self.topTool.status = status;
}

-(void)setupView{
    
    //添加上不工具条
    TopTool *topTool = [[TopTool alloc]init];
    [self addSubview:topTool];
    self.topTool = topTool;
    
    //添加下部工具条 没有 评价 或 转发 时 显示
    BottomTool *bottomTool = [[BottomTool alloc]init];
    [self addSubview:bottomTool];
    self.bottomTool = bottomTool;
    
}

// 初始 化 上下 连个 组件
-(void)layoutSubviews{
    //toptool
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topH = 44;
    CGFloat topW = self.bounds.size.width;
    self.topTool.frame = CGRectMake(topX, topY, topW, topH);
    
    //bottomtool
    CGFloat bottomX = 0;
    CGFloat bottomY = topH;
    CGFloat bottomH = 44;
    CGFloat bottomW = topW;
    self.bottomTool.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
}

/*
 *  拦截frame 调节cell宽度
 *
 *  @param frame frame description
 */
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width -= 2 * 5;
    
    [super setFrame:frame];
}
@end
