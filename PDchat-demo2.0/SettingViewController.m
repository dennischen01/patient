//
//  SettingViewController.m
//  doctor
//
//  Created by 陈希灿 on 2017/5/4.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "SettingViewController.h"
#import "changeImageViewController.h"
@interface SettingViewController ()
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
- (IBAction)changeImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width / 2;
    _avatarImageView.layer.masksToBounds = YES;
    // 当前登录的用户名
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *title = [NSString stringWithFormat:@"注销登录(%@)", loginUsername];
    
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
- (IBAction)changeImage:(id)sender {
    //跳转
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    changeImageViewController *changeVC=[storyboard instantiateViewControllerWithIdentifier:@"changeimage"];
    [self.navigationController pushViewController:changeVC animated:YES];
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
