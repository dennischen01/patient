//
//  AddDoctorViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/10.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "AddDoctorViewController.h"
#import "MBProgressHUD.h"
@interface AddDoctorViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberInput;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *hospital;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation AddDoctorViewController
- (IBAction)adddoctorBtn:(id)sender {
    NSLog(@"%@",self.doctorUsername);
    
   
    
    //取得手机号
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_phonenumber.php"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
    requset.HTTPMethod=@"POST";
    NSString *str=[NSString stringWithFormat:@"username=%@",self.doctorUsername];
    NSLog(@"patient username:%@",str);
    requset.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *phoneNumber=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //2.向服务器发送请求 message:请求添加好友的额外信息
        NSString *loginUserName=[[EaseMob sharedInstance].chatManager loginInfo][@"username"];
        NSLog(@"loginusername:%@",loginUserName);
        self.infoname=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"infoname:%@",self.infoname);
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSDictionary *info=[def objectForKey:@"info"];
        NSString *name=[info objectForKey:loginUserName];
        NSLog(@"%@",name);
        NSString *message=[NSString stringWithFormat:@"我是%@患者",name];
        NSLog(@"%@",message);
        EMError *emerror=nil;
        [[EaseMob sharedInstance].chatManager addBuddy:phoneNumber message:message error:&emerror];
        if (error) {
            NSLog(@"添加的好友有问题 %@",error);
            message = @"发生错误，请稍后再试";
        }else{
            NSLog(@"添加的好友没有问题");
            message = @"请求发送成功，请等待医生的同意";
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        
    }];
    [task resume];
    
    
}

- (void)viewDidLoad {
    _addButton.layer.cornerRadius = 5;
    //获取好友信息
    //    http://112.74.92.197/server/doctor_detail.php
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_detail.php"];
    NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
    requset.HTTPMethod=@"POST";
    NSString *requestBody=[NSString stringWithFormat:@"phonenumber=%@",self.doctorUsername];
    NSLog(@"传过来的手机号%@",self.doctorUsername);
    requset.HTTPBody=[requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSDictionary *dit=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"正在网络请求");
            NSLog(@"%@",dit);
            self.username.text=[dit objectForKey:@"username"];
            self.phonenumberInput.text=[dit objectForKey:@"phonenumber"];
            self.age.text=[dit objectForKey:@"age"];
            self.hospital.text=[dit objectForKey:@"hospital"];
            self.type.text=[dit objectForKey:@"type"];
            self.detail.text=[dit objectForKey:@"detail"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    [task resume];

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
