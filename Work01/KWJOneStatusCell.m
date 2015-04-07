//
//  KWJOneStatusCell.m
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJOneStatusCell.h"
#import "KWJTopView.h"

#import "KWJStatus.h"
#import "KWJStatusFrame.h"

@interface KWJOneStatusCell()

@property (nonatomic,strong) KWJTopView *topView;

@end

@implementation KWJOneStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    KWJOneStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJOneStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell选中时的背景
        self.selectedBackgroundView = [[UIView alloc]init];
        
        //添加顶部控件
        [self setupStatusTopView];
    }
    return self;
}

/*
 *  取得frame 时初始化 头部控件
 *
 *  @param statusFrame statusFrame description
 */
-(void)setStatusFrame:(KWJStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    [self setupStatusTopview];
}

/*
 *  添加头部控件
 */
-(void)setupStatusTopView{
    
    KWJTopView *topView = [[KWJTopView alloc]init];
    [self addSubview:topView];
    self.topView = topView;
    
}

/*
 *  初始化头部控件
 */
-(void)setupStatusTopview{
    self.topView.frame = self.statusFrame.topViewF;
    self.topView.statusFrame = self.statusFrame;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x = statusTableBorder;
    frame.size.width -= 2 * statusTableBorder;
    
    [super setFrame:frame];
}

@end
