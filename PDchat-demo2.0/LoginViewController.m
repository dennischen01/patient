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
#import "MBProgressHUD.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)touchview:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginbutton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTargetMethod];

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
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在登陆";
    
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            
            
            //获取中文名
            NSURLSession *session=[NSURLSession sharedSession];
            NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/patient/MyselfInfo.php"];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod=@"POST";
            NSString *str=[NSString stringWithFormat:@"phonenumber=%@",userName];
            NSData *body=[str dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPBody=body;
            NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"obj=%@",obj);
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSLog(@"obj= dictionary");
                    }
                    //写入NSUserDefaults
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setObject:obj forKey:@"selfinfo"];
                    NSLog(@"成功写入NSUserDefaults");
                    
                    
                    // 来主界面
                    self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                    [MBProgressHUD HUDForView:self.view];
                    
                });
                
                
                
                
            }];
            [task resume];


        }else{
            NSLog(@"登录失败:%@",error);
            [MBProgressHUD HUDForView:self.view];
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




- (IBAction)touchview:(id)sender {
    if ([self.userName isFirstResponder]) {
        [self.userName resignFirstResponder];
    }else if ([self.passWord isFirstResponder]){
        [self.passWord resignFirstResponder];
    }
}


- (void)addTargetMethod{
    [self.userName addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWord addTarget:self action:@selector(textField2TextChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)textField1TextChange:(UITextField *)textField{
    if (textField.text.length>0&&self.passWord.text.length>0) {
        self.loginbutton.enabled=YES;
    }else{
        self.loginbutton.enabled=NO;
    }
}

- (void)textField2TextChange:(UITextField *)textField{
    if (textField.text.length>0&&self.userName.text.length>0) {
        self.loginbutton.enabled=YES;
    }else{
        self.loginbutton.enabled=NO;
    }
}
@end
