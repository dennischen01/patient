//
//  AFNetworkingTool.h
//  patient
//
//  Created by 陈希灿 on 2017/5/8.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetworkingTool : NSObject


//验证手机号是否在数据库中注册
- (NSString *)isReigister:(NSURL *)urlAndphonenumer:(NSString *)phonenumber;

@end
