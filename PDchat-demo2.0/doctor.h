//
//  doctor.h
//  patient
//
//  Created by 陈希灿 on 2017/4/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doctor : NSObject
@property (nonatomic,retain)NSString *username;
@property (nonatomic,retain)NSString *age;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *gender;
@property (nonatomic,retain)NSString *phonenumber;
@property (nonatomic,retain)NSString *detail;
- (instancetype)initWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail;
+ (instancetype)initWithUsername:(NSString *)username andAge:(NSString *)Age andType:(NSString *)type andGender:(NSString *)gender andPhonenumber:(NSString *)phonenumber andDetail:(NSString *)detail;
- (instancetype)initWithUserName:(NSString *)username andType:(NSString *)type;
@end
