//
//  KWJResopt.m
//  Work01
//
//  Created by kwj on 14/12/13.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJRespot.h"
#import "UIImageView+WebCache.h"
#import "UIImage+KWJ.h"
#import "KWJStatusUser.h"

@interface KWJRespot()<UITextViewDelegate>

//被转发微博的 内容 模块
@property (nonatomic,weak)UIView *statusView;
//转发微博的 一张 配图
@property (nonatomic,weak)UIImageView *photoView;
//被转发微博的 用户名
@property (nonatomic,weak)UILabel *nameLabel;
//被转发微博的 内容
@property (nonatomic,weak)UILabel *statusLabel;

@property (nonatomic,weak)UILabel *tip;

@end

@implementation KWJRespot

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //转发 附带 文字
        UITextView *respotText = [[UITextView alloc]init];
        respotText.delegate = self;
        [respotText becomeFirstResponder];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 320, 25)];
        tip.text = @"说说分享心得..";
        tip.font = [UIFont fontWithName:@"Arial" size:15];
        tip.backgroundColor = [UIColor clearColor];
        tip.enabled = NO;
        [respotText addSubview:tip];
        self.tip = tip;
        
        [self addSubview:respotText];
        self.respotText = respotText;
        
        //转发微博的 一张 配图
        UIImageView *photoView = [[UIImageView alloc]init];
        [self addSubview:photoView];
        self.photoView = photoView;
        
        //被转发微博的 内容 模块
        UIView *statusView = [[UIView alloc]init];

        //被转发微博的 用户名
        UILabel *nameLabel = [[UILabel alloc]init];
        [statusView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //被转发微博的 内容
        UILabel *statusLabel = [[UILabel alloc]init];
        [statusView addSubview:statusLabel];
        self.statusLabel = statusLabel;
        
        [self addSubview:statusView];
        self.statusView = statusView;
    }
    return self;
}

//textView代理
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.tip.text = @"说说分享心得..";
    } else {
        self.tip.text = @"";
    }
}
//textview代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制最大长度
    if (range.location < 140)
    {
        return  YES;
    } else {
        return NO;
    }
}

-(void)setRespotFrame:(RespotFrame *)respotFrame{
    _respotFrame = respotFrame;
    _status = respotFrame.status;
    
    self.frame = respotFrame.respotF;
    
    self.respotText.font = RespotFont;
    self.respotText.textColor = [UIColor blackColor];
    
    if (_status.pic_urls.count > 0) {
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:_status.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
        self.photoView.backgroundColor = [UIColor redColor];
    }else{
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:_status.user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
        self.photoView.backgroundColor = [UIColor redColor];
    }
    
    self.statusView.backgroundColor = [UIColor grayColor];

    self.nameLabel.text = [NSString stringWithFormat:@"@%@", _status.user.name];
    self.nameLabel.font = NameFont;
    
    self.statusLabel.text = _status.text;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.font = StatusContentFont;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.respotText.frame = self.respotFrame.textViewF;
    
    self.photoView.frame = self.respotFrame.photoViewF;
    
    self.statusView.frame = self.respotFrame.statusViewF;
    
    self.nameLabel.frame = self.respotFrame.nameLabelF;
    
    self.statusLabel.frame = self.respotFrame.statusLabelF;
}

@end
