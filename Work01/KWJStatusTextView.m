//
//  KWJStatusTextView.m
//  Work01
//
//  Created by kwj on 14/12/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJStatusTextView.h"
#import "HeaderFile.h"

@interface KWJStatusTextView()<UITextViewDelegate>

@property (nonatomic,weak) UITextView *statusText;

@property (nonatomic,weak) UILabel *numberLabel;

@property (nonatomic,weak) UILabel *respotLabel;

@property (nonatomic,assign) int wordNumber;

@property (nonatomic,copy) NSString *respotStr;

@end

/* 正文的字体 */
#define statusContentFont [UIFont systemFontOfSize:15]

@implementation KWJStatusTextView

-(id)initWithRespot:(NSString *)respot maxWord:(int)num{
    if (self = [super init]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //输入文字上限
        self.wordNumber = num;
        
        //提示文字
        self.respotStr = respot;
        
        //加载 textview
        UITextView *statusText = [[UITextView alloc]init];
        statusText.delegate = self;
//        statusText.backgroundColor = KWJColor(251, 231, 223);
        statusText.font = [UIFont systemFontOfSize:14];
        [statusText becomeFirstResponder];
        [self addSubview:statusText];
        self.statusText = statusText;
        
        //加载label
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = [NSString stringWithFormat:@"%d/%d",0,self.wordNumber];
        numberLabel.font = [UIFont fontWithName:@"Arial" size:15];
        numberLabel.textColor = KWJColor(195, 195, 195);
        [self.statusText addSubview:numberLabel];
        self.numberLabel = numberLabel;
        
        if (respot != nil) {
            //加载提示语label
            UILabel *respotLabel = [[UILabel alloc] init];
            respotLabel.text = self.respotStr;
            respotLabel.textColor = KWJColor(195, 195, 195);
            respotLabel.font = [UIFont fontWithName:@"Arial" size:15];
            [self.statusText addSubview:respotLabel];
            self.respotLabel = respotLabel;
        }
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView{
    //统计字数
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,self.wordNumber];
    //提示字符
    if (self.respotStr != nil && textView.text.length == 0){
        self.respotLabel.hidden = NO;
    }
    else {
        self.respotLabel.hidden = YES;
    }
    
    //Block
    if (self.notempty != nil) {
        self.notempty(self.statusText.text);
    }
}

//textview代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制最大长度
    if (range.location < self.wordNumber){
        return  YES;
    } else {
        return NO;
    }
}

//初始化 各控件位置
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.statusText.frame = self.bounds;
    
    NSDictionary *contentFontDic = @{NSFontAttributeName:statusContentFont};
    
    CGSize wordNumberS = [[NSString stringWithFormat:@"%d/%d",self.wordNumber,self.wordNumber] sizeWithAttributes:contentFontDic];
    CGFloat wordNumberX = self.statusText.frame.size.width - wordNumberS.width - 10;
    CGFloat wordNumberY = self.statusText.frame.size.height - wordNumberS.height - 5;
    self.numberLabel.frame = (CGRect){{wordNumberX,wordNumberY},wordNumberS};
    
    CGSize respotS = [self.respotStr sizeWithAttributes:contentFontDic];
    CGFloat respotX = self.statusText.frame.origin.x + 5;
    CGFloat respotY = self.statusText.frame.origin.y + 5;
    self.respotLabel.frame = (CGRect){{respotX,respotY},respotS};
    
}

-(NSString *)getText{
    return self.statusText.text;
}

-(void)setText:(NSString *)text{
    self.statusText.text = text;
//    if (self.statusText.text.length > 0) {
//        self.respotLabel.hidden = YES;
//    }else{
//        self.respotLabel.hidden = NO;
//    }
    [self textViewDidChange:self.statusText];
}

@end
