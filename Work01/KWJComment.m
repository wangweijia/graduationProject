//
//  KWJComment.m
//  Work01
//
//  Created by kwj on 14/12/9.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJComment.h"
#import "HeaderFile.h"

@implementation KWJComment

+ (instancetype)commentWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

//created_at	string	评论创建时间
//@property (nonatomic,copy) NSString *created_at;

//text	string	评论的内容
//@property (nonatomic,copy) NSString *text;

//user	object	评论作者的用户信息字段 详细
//@property (nonatomic,strong) KWJStatusUser *user;

//idstr	string	字符串型的评论ID
//@property (nonatomic,copy) NSString *idstr;

//reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _created_at = dic[@"created_at"];
        _idstr = dic[@"idstr"];
        _text = dic[@"text"];
        _user = [KWJStatusUser userWithDic:dic[@"user"]];
    }
    return self;
}

- (NSMutableAttributedString *)contents{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_text];
    
    int loc = 0;
    int length = (int)_text.length;
    
    while ((int)[_text rangeOfString:@"@" options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location > -1){
        
        int locs = (int)[_text rangeOfString:@"@" options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location;
        //判断 “：”
        if ( (int)[_text rangeOfString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location > -1 ){
            
            int lengths = (int)[_text rangeOfString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location - locs;
            
            [str addAttribute:NSForegroundColorAttributeName value:KWJColor(67, 107, 163) range:NSMakeRange(locs,lengths)];
            
            loc = (int)[_text rangeOfString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location + 1;
            length = (int)_text.length - loc;
        //判断 “ ”
        }else if( (int)[_text rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location > -1 ){

            int lengths = (int)[_text rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location - locs;
            
            [str addAttribute:NSForegroundColorAttributeName value:KWJColor(67, 107, 163) range:NSMakeRange(locs,lengths)];
            
            loc = (int)[_text rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location + 1;
            length = (int)_text.length - loc;
            
        }else{

            int lengths = (int)_text.length - locs;
            
            [str addAttribute:NSForegroundColorAttributeName value:KWJColor(67, 107, 163) range:NSMakeRange(locs,lengths)];
            
            break;
        }
    }
    
    loc = 0;
    length = 0;
    
    while ((int)[_text rangeOfString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location > -1) {
        
        int locs = (int)[_text rangeOfString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(loc, length)].location;
        
        if ( (int)[_text rangeOfString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location > -1 ) {
            
            int lengths = (int)[_text rangeOfString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(locs, (int)_text.length - locs)].location - locs;
            
            [str addAttribute:NSForegroundColorAttributeName value:KWJColor(67, 107, 163) range:NSMakeRange(locs,lengths)];
            
            break;
        }
    }
    
    return str;
}

-(NSString *)created_at{
    
    NSString *format = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    NSDate *createdDate = [fmt dateFromString:_created_at];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *myCmps = [calendar components:unit fromDate:createdDate];
    
    return [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)myCmps.year,(long)myCmps.month,(long)myCmps.day,(long)myCmps.hour,(long)myCmps.minute];
}

@end
