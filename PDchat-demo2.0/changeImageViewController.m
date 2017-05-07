//
//  changeImageViewController.m
//  doctor
//
//  Created by 陈希灿 on 2017/4/22.
//  Copyright © 2017年 hdu. All rights reserved.
//
#import "changeImageViewController.h"
#import "QiniuSDK.h"
@interface changeImageViewController ()<UIImagePickerControllerDelegate>

- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation changeImageViewController

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

//上传到七牛云存储
- (IBAction)submit:(id)sender {
    //1.取得手机号
    NSString *phonenumber = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    //2.取得当前时间 格式 时：分
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"_MMddHHmm"];
    NSString *datestring=[formatter stringFromDate:date];
    NSString *key=[phonenumber stringByAppendingString:datestring];
    NSLog(@"key=%@",key);
    //2.取得图片，命名url
    UIImage *selectedImage=self.imageview.image;
    NSString *token=@"H-GScmCdu0ey0PBh32ImwORnjINFNpZtVOca7wU8:Qawwm_BJC26l58zu6HPGFEFs1NI=:ewogICJzY29wZSIgOiAiY2hhdGltYWdlIiwKICAiZGVhZGxpbmUiIDogMTQ5NDMxMjI5OAp9";
    QNUploadManager *manager=[[QNUploadManager alloc]init];
    NSData *data=UIImageJPEGRepresentation(selectedImage, 1.0);
    [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@",info);
    } option:nil];
    NSString *imageurl=[@"http://oo3gvaa9x.bkt.clouddn.com/" stringByAppendingString:key];
    NSString *urlstring=@"http://112.74.92.197/server/doctor_changeImage.php";
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:urlstring];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString *postbody=[NSString stringWithFormat:@"phonenumber=%@&&imageurl=%@",phonenumber,imageurl];
    request.HTTPBody=[postbody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *res=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (![res isEqualToString:@"fail"] ){
            NSLog(@"服务器修改url成功");
        }else NSLog(@"error=%@",error);
        
    }];
    [task resume];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *imagepath=[docDir stringByAppendingString:@"/Documents/test.jpg"];
    NSLog(@"imagepath=%@",imagepath);
    [UIImageJPEGRepresentation(selectedImage, 1.0)writeToFile:imagepath atomically:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:imagepath forKey:@"imagepath"];
}

- (IBAction)upload:(id)sender {
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
    self.imageview.image=image;
    NSLog(@"pick后%@",self.imageview.image);
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
