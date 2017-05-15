//
//  DetailViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/7.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberInput;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *hospital;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UILabel *detail;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取好友信息
    //    http://112.74.92.197/server/doctor_detail.php
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_detail.php"];
    NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
    requset.HTTPMethod=@"POST";
    NSString *requestBody=[NSString stringWithFormat:@"phonenumber=%@",self.phonenumber];
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
            [self.imageview sd_setImageWithURL:[dit objectForKey:@"imageurl"] placeholderImage:[UIImage imageNamed:@"ali"]];
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
