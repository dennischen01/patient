//
//  DoctorDetailViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/10.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "MBProgressHUD.h"
@interface DoctorDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberInput;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *hospital;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation DoctorDetailViewController
/*
- (IBAction)adddoctorBtn:(id)sender {
    //取得手机号
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_phonenumber.php"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
    requset.HTTPMethod=@"POST";
    NSString *str=[NSString stringWithFormat:@"username=%@",self.doc.phonenumber];
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

*/
- (void)viewDidLoad {
    _addButton.layer.cornerRadius = 5;
    self.username.text=self.doc.username;
    self.phonenumberInput.text=self.doc.phonenumber;
    self.age.text=self.doc.age;
    self.hospital.text=self.doc.hospital;
    self.type.text=self.doc.type;
    self.detail.text=self.doc.detail;
    

}

- (void)setDoc:(doctor *)doc{
    _doc = doc;
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
