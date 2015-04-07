//
//  NSDate+KWJ.m
//  Work01
//
//  Created by kwj on 14/12/6.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "NSDate+KWJ.h"

@implementation NSDate (KWJ)

/*
 *  输入年夜日 小时 分 秒 返回与当前时间的对比
 *
 *  @param date 时间
 *  @param format 时间格式
 *
 *  @return 对比结果
 */
+(NSString *)dateWith:(NSString *)date dateFormat:(NSString *)format{
    // _created_at == Fri May 09 16:30:34 +0800 2014
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    NSDate *createdDate = [fmt dateFromString:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:createdDate];
    
    if (nowCmps.year == myCmps.year) {
        //同一年
        if (nowCmps.month == myCmps.month) {
            //同一个月
            if ([calendar isDateInToday:createdDate]) {
                //同一天
                if (nowCmps.hour == myCmps.hour) {
                    //同一个小时里
                    if (nowCmps.minute == myCmps.minute) {
                        //刚刚
                        return @"刚刚";
                    }else{
                        //分钟
                        return [NSString stringWithFormat:@"%ld分钟前",(nowCmps.minute - myCmps.minute)];
                    }
                }else
                {
                    //不再同一个小时
                    return [NSString stringWithFormat:@"%ld小时前",(nowCmps.hour - myCmps.hour)];
                }
            }else if ([calendar isDateInYesterday:createdDate]){
                //是昨天
                fmt.dateFormat = @"HH:mm";
                return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createdDate]];
            }
            else{
                fmt.dateFormat = @"MM-dd HH:mm";
                return [fmt stringFromDate:createdDate];
            }
        }else{
            //不是同一个月
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createdDate];
        }
    }else{
        //不是同一年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}


@end
