//
//  EditViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/4/18.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "EditViewController.h"
@interface EditViewController ()
@end

@implementation EditViewController
- (BOOL)isPassword{
    if (!_isPassword) {
        _isPassword=NO;
    }
    return _isPassword;
}
- (IBAction)save:(id)sender {
    self.selectedString=self.EditTextField.text;
    if(self.selectblock){
        self.selectblock(self.selectedString);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.EditTextField.secureTextEntry=self.isPassword;
    NSLog(@"self.ispassword=%d",self.isPassword);
    self.EditTextField.text=self.text;
    NSLog(@"self.secureentry=%d",self.EditTextField.secureTextEntry);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
