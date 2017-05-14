//
//  doctor.m
//  patient
//
//  Created by 陈希灿 on 2017/4/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "doctor.h"

@implementation doctor
- (instancetype)initWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail andImageurl:(NSString *)imageurl andHospital:(NSString *)hospital{
    if (self=[super init]) {
        self.username=username;
        self.age=Age;
        self.type=type;
        self.gender=gender;
        self.phonenumber=phonenumber;
        self.detail=detail;
        self.imageurl=imageurl;
        self.hospital=hospital;
    }
    return self;
    
}

+ (instancetype)doctorWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail andImageurl:(NSString *)imageurl andHospital:(NSString *)hospital{
    doctor *doctor1=[[doctor alloc]initWithUsername:username andAge:Age andType:type andGender:gender andPhonenumber:phonenumber andDetail:detail andImageurl:imageurl andHospital:hospital];
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
