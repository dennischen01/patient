//
//  DoctorDetailViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/10.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface DoctorDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *hospital;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberInput;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *detail;

@end

@implementation DoctorDetailViewController

- (IBAction)adddoctorBtn:(id)sender {
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSDictionary *info=[def objectForKey:@"selfinfo"];
    NSString *name=[info objectForKey:@"username"];
    NSLog(@"%@",name);
    NSString *message=[NSString stringWithFormat:@"我是%@患者",name];
    NSLog(@"%@",message);
    EMError *emerror=nil;
    [[EaseMob sharedInstance].chatManager addBuddy:self.doc.phonenumber message:message error:&emerror];
    if (!self.doc.phonenumber) {
        NSLog(@"添加的好友有问题");
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
    
    
}



- (void)viewDidLoad {
    _addButton.layer.cornerRadius = 5;
    self.username.text=self.doc.username;
    self.phonenumberInput.text=self.doc.phonenumber;
    self.age.text=self.doc.age;
    self.type.text=self.doc.type;
    self.detail.text=self.doc.detail;
    [self.image sd_setImageWithURL:self.doc.imageurl placeholderImage:[UIImage imageNamed:@"ali"]];
    self.hospitalTextField.text=self.doc.hospital;
    
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
