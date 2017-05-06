


//
//  patient.m
//  patient
//
//  Created by 陈希灿 on 2017/4/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "patient.h"

@implementation patient
- (instancetype)initWithUserName:(NSString *)username andType:(NSString *)type{
    if (self=[self init]) {
        self.username=username;
        self.type=type;
    }
    return self;
}
@end
