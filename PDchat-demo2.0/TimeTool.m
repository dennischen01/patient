//
//  TimeTool.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/2.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+(NSString *)timeStr:(long long)timestamp{
    //返回时间格式
    
    
    //currentDate 2017-04-02 16:28:09 +0000
    //msgDate 2015-04-02 10:36:22 +0000
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //1.获取当前的时间
    NSDate *currentDate = [NSDate date];
    
    // 获取年，月，日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    
    //2.获取消息发送时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    // 获取年，月，日
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYead = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    
    //3.判断:
    /*今天：(HH:mm)
     *昨天: (昨天 HH:mm)
     *昨天以前:（2015-09-26 15:27）
     */
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYead
        && currentMonth == msgMonth
        && currentDay == msgDay) {//今天
        dateFmt.dateFormat= @"HH:mm";
    }else if(currentYear == msgYead
             && currentMonth == msgMonth
             && currentDay - 1 == msgDay){//昨天
        dateFmt.dateFormat= @"昨天 HH:mm";
    }else{//昨天以前
        dateFmt.dateFormat= @"yyy-MM-dd HH:mm";
    }
    
    
    return [dateFmt stringFromDate:msgDate];
}


@end
