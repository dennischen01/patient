//
//  GetCodeViewController.m
//  doctor
//
//  Created by 陈希灿 on 2017/4/19.
//  Copyright © 2017年 hdu. All rights reserved.
//获取验证码界面

#import "GetCodeViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "RegisterTableViewController.h"


@interface GetCodeViewController ()<UIAlertViewDelegate>
- (IBAction)submit:(id)sender;


@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)submit:(id)sender {
    [SMSSDK commitVerificationCode:self.VerificationCode.text phoneNumber:self.phoneNumber zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        {
            if (!error)
            {
                
                //验证手机号是否在数据库中注册：若没有，跳到注册界面 isRegister.php
                //若有，则直接跳到消息列表
                //向后台传手机号，后台返回fail/success；
                NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_isRegister.php"];
                NSURLSession *session=[NSURLSession sharedSession];
                NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
                requset.HTTPMethod=@"POST";
                NSString *str=[NSString stringWithFormat:@"phonenumber=%@",self.phoneNumber];
                requset.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
                NSURLSessionTask *task=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSString *res=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",res);
                    if ([res isEqualToString:@"success"]) {
                        //要在主线程切换UI
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已注册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
                            [alert show];
                            
                        });
                        
                        
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳到下一个界面，输入个人信息
                            UIStoryboard *storybord=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
                            RegisterTableViewController *registerVC=[storybord instantiateViewControllerWithIdentifier:@"RegistertableVC"];
                            [self.navigationController pushViewController:registerVC animated:YES];
                            registerVC.phonenumber=self.phoneNumber;
                            
                        });
                        
                        
                    }
                }];
                [task resume];
                
            }
            else
            {
                NSLog(@"错误信息:%@",error);
            }
        }
    }];
    
}

//按取消键动作
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //按'取消'键动作

        //返回到输手机号界面
//        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        //按'我知道了'键动作
        self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    }
}


@end
