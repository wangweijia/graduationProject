//
//  SectionCell.m
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SectionCell.h"
#import "SecondLevel.h"

@interface SectionCell()

//显示标题
@property (nonatomic,weak) UILabel *titleLabel;

//work 按钮
@property (nonatomic,weak) KWJLableButton *wordButton;
//ppt 按钮
@property (nonatomic,weak) KWJLableButton *pptButton;
//video 按钮
@property (nonatomic,weak) KWJLableButton *videoButton;


@end

@implementation SectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"section";
    SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //cell选中时的反应
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell设置背景图片
        UIImageView *bgImage = [[UIImageView alloc]init];
        bgImage.frame = self.bounds;
        bgImage.image = [UIImage imageNamed:@"course_cell_bg"];
        self.backgroundView = bgImage;
        
        //word
        KWJLableButton *wordButton = [KWJLableButton labelButtonWithImage:@"words"];
        wordButton.frame = CGRectMake(228, 0, 44, 44);
        
        [self.contentView addSubview:wordButton];
        _wordButton = wordButton;
        
        //ppt
        KWJLableButton *pptButton = [KWJLableButton labelButtonWithImage:@"ppts"];
        pptButton.frame = CGRectMake(278, 0, 44, 44);
        
        [self.contentView addSubview:pptButton];
        _pptButton = pptButton;
        
        //voideo//pdf
        KWJLableButton *voideoButton = [KWJLableButton labelButtonWithImage:@"pdfs"];
        voideoButton.frame = CGRectMake(326, 0, 44, 44);
        
        [self.contentView addSubview:voideoButton];
        _videoButton = voideoButton;
        
        //title label
        UILabel *titleLbale = [[UILabel alloc]init];
        titleLbale.frame = CGRectMake(5, 0, 220, 44);
//        titleLbale.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview:titleLbale];
        _titleLabel = titleLbale;
    }
    
    return self;
}

- (void)setSecondLevel:(SecondLevel *)secondLevel buttonDeleget:(id)object{
    _secondLevel = secondLevel;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@  %@",_secondLevel.title,_secondLevel.subtitle];
    
    [_wordButton setNumber:[NSString stringWithFormat:@"%lu",(unsigned long)_secondLevel.word.count] Title:@"word" CoursewareArray:_secondLevel.word];
    _wordButton.delegates = object;
    [_pptButton setNumber:[NSString stringWithFormat:@"%lu",(unsigned long)_secondLevel.ppt.count] Title:@"ppt" CoursewareArray:_secondLevel.ppt];
    _pptButton.delegates = object;
//    [_videoButton setNumber:[NSString stringWithFormat:@"%lu",(unsigned long)_secondLevel.video.count] Title:@"video"CoursewareArray:_secondLevel.video];
//    _videoButton.delegates = object;
    [_videoButton setNumber:[NSString stringWithFormat:@"%lu",(unsigned long)_secondLevel.video.count] Title:@"pdf" CoursewareArray:_secondLevel.pdf];
    _videoButton.delegates = object;
}

@end
