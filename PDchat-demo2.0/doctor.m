//
//  doctor.m
//  patient
//
//  Created by 陈希灿 on 2017/4/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "doctor.h"

@implementation doctor
- (instancetype)initWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail andImageurl:(NSString *)imageurl{
    if (self=[super init]) {
        self.username=username;
        self.age=Age;
        self.type=type;
        self.gender=gender;
        self.phonenumber=phonenumber;
        self.detail=detail;
        self.imageurl=imageurl;
    }
    return self;
    
}

+ (instancetype)initWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail andImageurl:(NSString *)imageurl{
    doctor *doctor1=[doctor1 initWithUsername:username andAge:Age andType:type andGender:gender andPhonenumber:phonenumber andDetail:detail andImageurl:imageurl];
    return doctor1;
}

- (instancetype)initWithUserName:(NSString *)username andType:(NSString *)type andImageurl:(NSString *)imageurl{
    if (self=[super init]) {
        self.username=username;
        self.type=type;
        self.imageurl=imageurl;
    }
    return self;
}
@end
