//
//  SettingViewController.m
//  doctor
//
//  Created by 陈希灿 on 2017/5/4.
//  Copyright © 2017年 hdu. All rights reserved.
//
#import "AFNetworking.h"
#import "SettingViewController.h"
#import "changeImageViewController.h"
#import "UIImageView+WebCache.h"
@interface SettingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
- (IBAction)changeImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property NSString *imagePath;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingString:@"myImage.jpg"];
    
    //如果沙盒有，取沙盒，否则，去服务器取
    UIImage *image=[[UIImage alloc]initWithContentsOfFile:path];
    if(image!=nil){
        self.avatarImageView.image=image;
    }else{
        self.avatarImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>
    }
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
    //显示图片选择的控制器
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    //设置元
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate=self;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //选择图片的回调
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    self.avatarImageView.image=image;
    //写入沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingString:@"myImage.jpg"];
    [UIImageJPEGRepresentation(image, 0.5) writeToFile:path atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //上传到服务器
    
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    
    [session POST:@"http://112.74.92.197/server/uploadHead.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSURL *url=[NSURL fileURLWithPath:path];
        
        [formData appendPartWithFileURL:url name:@"file" fileName:@"5.9.jpg" mimeType:@"image/jpg" error:nil];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        
    }];
    
    
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
