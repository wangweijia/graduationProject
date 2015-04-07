//
//  KWJCommentCell.m
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+KWJ.h"

@interface KWJCommentCell()

@property (nonatomic ,weak) UIImageView *iconView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *timelabel;

@property (nonatomic ,weak) UILabel *contentLabel;

@end

@implementation KWJCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"comment";
    KWJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //选中背景
        self.selectedBackgroundView = [[UIView alloc]init];
        
        //cell背景
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage resizedImageWithName:@"cell_comment_bg2"];
        self.backgroundView = image;
        
        [self setupView];
    }
    return self;
}

/*
 *  创建个组件
 */
-(void)setupView{
    //头像
    UIImageView *icomView = [[UIImageView alloc]init];
    [self addSubview:icomView];
    self.iconView =icomView;
    
    //名字
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = CommentNameFont;
    nameLabel.text = @"name";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = CommentTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    timeLabel.text = @"time";
    [self addSubview:timeLabel];
    self.timelabel = timeLabel;
    
    //正文
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = CommentContentFont;
//    contentLabel.text = @"text";
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
}

/*
 *  初始化 控件
 */
-(void)layoutSubviews{
    
    [super layoutSubviews];
    _comment = self.commentFrame.comment;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_comment.user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    self.iconView.frame = self.commentFrame.iconViewF;
    
    self.nameLabel.text = _comment.user.name;
    self.nameLabel.frame = self.commentFrame.nameViewF;
    
    self.timelabel.text = _comment.created_at;
    self.timelabel.frame = self.commentFrame.timeViewF;
    
    self.contentLabel.attributedText = [_comment contents];
    self.contentLabel.frame = self.commentFrame.contentViewF;
}

/*
 *  拦截frame 调节cell宽度
 *
 *  @param frame frame description
 */
-(void)setFrame:(CGRect)frame{
    frame.origin.x = TableBorder;
    frame.size.width -= 2 * TableBorder;
    
    [super setFrame:frame];
}
@end
