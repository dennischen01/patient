//
//  RegisterDetailViewController.h
//  doctor
//
//  Created by 陈希灿 on 2017/4/20.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *detail);
@interface RegisterDetailViewController : UIViewController
@property (nonatomic,copy)SelectedBlock selectblock;
@end
