//
//  GenderTableViewController.h
//  patient
//
//  Created by 陈希灿 on 2017/4/18.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedGenderBlock)(NSString *gender);
@interface GenderTableViewController : UITableViewController
@property (nonatomic,copy) SelectedGenderBlock selectedGenderBlock;
@property (nonatomic,copy)NSString *selectedGender;
@end
