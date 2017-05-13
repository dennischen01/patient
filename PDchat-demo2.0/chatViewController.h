//
//  chatViewController.h
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/28.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *receiverCell=@"ReceiverCell";
static NSString *senderCell=@"SenderCell";

//定义一个协议往另一个viewcontroller传username
@protocol PassTrendValueDelegate
-(void)passTrendValues:(NSString *)values;//1.1定义协议与方法
@end



@interface chatViewController : UIViewController
/** 好友 */
@property(nonatomic,strong)EMBuddy *buddy;

@property(nonatomic,copy)NSString *imageurl;

///1.定义向趋势页面传值的委托变量
@property (retain,nonatomic) id <PassTrendValueDelegate> trendDelegate;

@end
