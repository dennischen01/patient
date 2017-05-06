//
//  AudioPlayTool.h
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/31.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayTool : NSObject

+ (void)playwithMessage:(EMMessage *)msg msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver;
+ (void)stop;

@end
