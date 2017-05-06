//
//  LoginViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/26.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "LoginViewController.h"
#import "EaseMob.h"
#import "VerificationViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
#pragma mark 登陆
- (IBAction)Login:(id)sender {
    // 让环信sdk在登录完成之后，自动从服务器获取好友列表
    NSString *userName=self.userName.text;
    NSString *password=self.passWord.text;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            // 来主界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
            //获取中文名
            NSURLSession *session=[NSURLSession sharedSession];
            NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/patient_username.php"];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod=@"POST";
            NSString *str=[NSString stringWithFormat:@"phonenumber=%@",userName];
            NSData *body=[str dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPBody=body;
            NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString *name=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"name=%@",name);
                    NSDictionary *dit=[NSDictionary dictionaryWithObject:name forKey:userName];
                    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
                    [user setObject:dit forKey:@"info"];
                    NSLog(@"%@",dit);
                });
                
                
            }];
            [task resume];


        }else{
            NSLog(@"登录失败:%@",error);
        }
    } onQueue:nil];
    
}
#pragma mark 注册
//跳到验证码登陆/注册
- (IBAction)Register:(id)sender {
//    NSString *userName=self.userName.text;
//    NSString *password=self.passWord.text;
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
//        if (!error) {
//            NSLog(@"注册成功");
//        }else{
//            NSLog(@"注册失败 %@",error);
//        }
//    } onQueue:nil];
//}
    //跳转到VerificationViewController(输入手机号界面)
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    VerificationViewController *veriVC=[storyboard instantiateViewControllerWithIdentifier:@"veriVC"];
    [self.navigationController pushViewController:veriVC animated:YES];
    
}
@end
