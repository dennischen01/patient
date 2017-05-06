
//
//  VerificationViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/6.
//  Copyright © 2017年 hdu. All rights reserved.
//  输入手机号界面

#import "VerificationViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "GetCodeViewController.h"

@interface VerificationViewController ()
- (IBAction)touchView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.phoneNumber addTarget:self action:@selector(TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.nextBtn.enabled=NO;
    
}

//监听输入框变化
-(void)TextChange:(UITextField *)textField{
    if(textField.text.length!=11){
        self.nextBtn.enabled=NO;
    }else{
        self.nextBtn.enabled=YES;
    }
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
//获取验证码按钮：默认中国手机号码
- (IBAction)GetVerificationCode:(id)sender {
    NSString *phoneNum=self.phoneNumber.text;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     };
                                 }];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    GetCodeViewController *codeVC=[storyboard instantiateViewControllerWithIdentifier:@"code"];
    codeVC.phoneNumber=self.phoneNumber.text;
    [self.navigationController pushViewController:codeVC animated:YES];
   }

//隐藏键盘
- (IBAction)touchView:(id)sender {
    if ([self.phoneNumber isFirstResponder]) {
        [self.phoneNumber resignFirstResponder];
    }
}

@end
