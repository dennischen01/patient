//
//  UsernameTool.h
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/8.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsernameTool : NSObject<NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableData *mResponseData;
@property(nonatomic,copy)NSString *name;
- (NSString *)getUsername:(NSString *)phoneNumber andIspatient:(BOOL)isPatient;
@end
