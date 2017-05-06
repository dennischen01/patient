//
//  SettingTableViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/26.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "SettingTableViewController.h"
#import "EaseMob.h"
#import "UsernameTool.h"

@interface SettingTableViewController ()
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 当前登录的用户名
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *title = @"注销登录";
    
    //1.设置退出按钮的文字
    [self.logoutBtn setTitle:title forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)logout:(id)sender {
    //UnbindDeviceToken 不绑定DeviceToken
    // DeviceToken 推送用
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            NSLog(@"退出失败 %@",error);
            
        }else{
            NSLog(@"退出成功");
            // 回到登录界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
            
        }
    } onQueue:nil];

    
}
@end
