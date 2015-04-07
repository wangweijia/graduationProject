//
//  KWJLableButton.m
//  Work01
//
//  Created by kwj on 14/11/24.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJLableButton.h"
#import "HeaderFile.h"

@interface KWJLableButton()

//按钮右上方 显示的数字
@property (nonatomic,weak) UILabel *numberLabel;


@end

@implementation KWJLableButton

+(instancetype)labelButtonWithImage:(NSString *)image{
    KWJLableButton *button = [[KWJLableButton alloc]initWithImage:image];
    
    return button;
}

-(id)initWithImage:(NSString *)image{
    if (self = [super init]) {
        
        //对自己属性设定
        self.frame = CGRectMake(0, 0, 44, 44);
//        self.backgroundColor = [UIColor yellowColor];
        if (image != nil) {
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        
        //label 属性设定
        UILabel * numberView = [[UILabel alloc]init];
        numberView.frame = CGRectMake(22, 2, 20, 20);
        numberView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        numberView.textAlignment = NSTextAlignmentCenter;
        numberView.textColor = [UIColor whiteColor];
        numberView.font = [UIFont fontWithName:@"Arial" size:15];
        
        //设置圆角
        numberView.layer.cornerRadius = 10.0;
        numberView.layer.masksToBounds=YES;
        
        [self addSubview:numberView];
//        [self.layer.contents addSubview:numberView];
        _numberLabel = numberView;
    }
    
    return self;
}

-(void)setNumber:(NSString *)number Title:(NSString *)title CoursewareArray:(NSArray *)array{
    _numberLabel.text = number;
    _coursewareArray = array;
    _title = title;
}

-(void)buttonClick{
    if ([self.delegates respondsToSelector:@selector(labelButtonClick:)]) {
        [self.delegates labelButtonClick:self];
    }
}

@end
