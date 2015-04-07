//
//  KWJFriendCell.m
//  Work01
//
//  Created by kwj on 14/12/22.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJFriendCell.h"
#import "KWJFriends.h"
#import "UIImageView+WebCache.h"
#import "UIImage+KWJ.h"
#import "HeaderFile.h"

@interface KWJFriendCell()

@property (nonatomic,weak)UIImageView *icoImage;

@property (nonatomic,weak)UILabel *nameLabel;

@property (nonatomic,weak)UILabel *screen_nameLabel;

@property (nonatomic,weak)UIImageView *selectImage;

@end

@implementation KWJFriendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"friend";
    KWJFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[KWJFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell选中时的背景
        self.selectedBackgroundView = [[UIView alloc]init];
//        UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"friend_cell_bg"]];
//        self.backgroundView = bgImage;
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"friend_cell_bg"]];
        
        UIImageView *icoImage = [[UIImageView alloc] init];
        [self addSubview:icoImage];
        self.icoImage = icoImage;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *screen_nameLabel;
        screen_nameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:screen_nameLabel];
        self.screen_nameLabel = screen_nameLabel;
        
        UIImageView *selectImage = [[UIImageView alloc] init];
//        selectImage.hidden = YES;
        selectImage.image = [UIImage imageNamed:@"NO"];
        selectImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:selectImage];
        self.selectImage = selectImage;
    }
    return self;
}

-(void)setFriends:(KWJFriends *)friends{
    _friends = friends;
    
    [self.icoImage sd_setImageWithURL:[NSURL URLWithString:friends.profile_image_url] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
    
    self.nameLabel.text = friends.name;
    
    self.screen_nameLabel.text = friends.screen_name;
    
    if (friends.isSelected) {
        self.backgroundColor = [UIColor grayColor];
        self.backgroundColor = KWJColor(244, 244, 244);
    }else{
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"friend_cell_bg"]];
        self.backgroundColor = nil;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat icoX = 15;
    CGFloat icoY = 5;
    CGFloat icoW = 35;
    CGFloat icoH = 35;
    self.icoImage.frame = CGRectMake(icoX, icoY, icoW, icoH);
    
    CGFloat nameX = CGRectGetMaxX(self.icoImage.frame) + 5;
    CGFloat nameY = icoY;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize nameS = [_friends.name boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.nameLabel.frame = (CGRect){{nameX,nameY},nameS};
    
    CGFloat screenX = nameX;
    CGFloat screenY = CGRectGetMaxY(self.nameLabel.frame);
    dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize screenS = [_friends.screen_name boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.screen_nameLabel.frame = (CGRect){{screenX,screenY},screenS};
    
    CGFloat selectWH = 22;
    CGFloat selectX = self.frame.size.width - selectWH - 20;
    CGFloat selectY = 11;
    self.selectImage.frame = CGRectMake(selectX, selectY, selectWH, selectWH);
}

-(void)cellIsSelected:(BOOL)select{
    if (select) {
//        self.selectImage.hidden = NO;
        _selectImage.image = [UIImage imageNamed:@"OK"];
    }else{
//        self.selectImage.hidden = YES;
        _selectImage.image = [UIImage imageNamed:@"NO"];
    }
}

@end
