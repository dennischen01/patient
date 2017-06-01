//
//  PrepareForChatViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/6/1.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "PrepareForChatViewController.h"
#import "chatViewController.h"

#import "DoctorDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FullDetailViewController.h"
@interface PrepareForChatViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *hospital;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberInput;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation PrepareForChatViewController

- (IBAction)adddoctorBtn:(id)sender {
    //进入到聊天控制器
    //1.从storybaord加载聊天控制器
    chatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPage"];
    
    //2.设置好友属性
    chatVc.buddy = self.buddy;
    doctor *d=self.doc;
    chatVc.title=d.username;
    chatVc.imageurl=d.imageurl;
    //3.展现聊天界面
    [self.navigationController pushViewController:chatVc animated:YES];
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
    
    UITapGestureRecognizer *tag=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailLabelTap:)];
    [self.detail addGestureRecognizer:tag];
    
}

- (void)detailLabelTap:(UITapGestureRecognizer*)recongnizer{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FullDetailViewController *fullDet=[storyboard instantiateViewControllerWithIdentifier:@"fulldetail"];
    fullDet.detail=self.detail.text;
    [self.navigationController pushViewController:fullDet animated:YES];
    
}

- (void)setDoc:(doctor *)doc{
    _doc = doc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
