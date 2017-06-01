//
//  PrepareForChatViewController.h
//  patient
//
//  Created by 陈希灿 on 2017/6/1.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doctor.h"

@interface PrepareForChatViewController : UIViewController
@property (strong,nonatomic) doctor *doc;
@property(nonatomic,strong)EMBuddy *buddy;
@end
