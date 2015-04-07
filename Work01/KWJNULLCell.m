//
//  KWJNULLCell.m
//  Work01
//
//  Created by kwj on 14/12/27.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJNULLCell.h"

@interface KWJNULLCell()

@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation KWJNULLCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"null";
    
    KWJNULLCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KWJNULLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.textColor = [UIColor grayColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLable];
        self.titleLabel = titleLable;
    }
    return self;
}

-(void)layoutSubviews{
    self.titleLabel.frame = self.bounds;
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

@end
