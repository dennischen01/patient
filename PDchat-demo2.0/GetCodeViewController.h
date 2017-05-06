//
//  GetCodeViewController.h
//  doctor
//
//  Created by 陈希灿 on 2017/4/19.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCodeViewController : UIViewController
@property(nonatomic,retain) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCode;

@end
