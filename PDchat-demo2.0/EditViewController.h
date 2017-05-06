//
//  EditViewController.h
//  patient
//
//  Created by 陈希灿 on 2017/4/18.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedBlock)(NSString *string);
@interface EditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *EditTextField;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)SelectedBlock selectblock;
@property (nonatomic,copy)NSString *selectedString;
@property BOOL isPassword;
@end
