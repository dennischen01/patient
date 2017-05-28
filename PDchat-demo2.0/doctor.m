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


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.phonenumber forKey:@"phonenumber"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.imageurl forKey:@"imageurl"];
    [aCoder encodeObject:self.hospital forKey:@"hospital"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.age=[aDecoder decodeObjectForKey:@"age"];
        self.type=[aDecoder decodeObjectForKey:@"type"];
        self.gender=[aDecoder decodeObjectForKey:@"gender"];
        self.phonenumber=[aDecoder decodeObjectForKey:@"phonenumber"];
        self.detail=[aDecoder decodeObjectForKey:@"detail"];
        self.imageurl=[aDecoder decodeObjectForKey:@"imageurl"];
        self.hospital=[aDecoder decodeObjectForKey:@"hospital"];
    }
    return self;
}

@end
