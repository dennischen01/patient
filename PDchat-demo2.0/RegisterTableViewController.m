//
//  RegisterTableViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/4/18.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "EditViewController.h"
#import "GenderTableViewController.h"
#import "RegisterTableViewCell.h"
#import "RegisterDetailViewController.h"
#import "EaseMob.h"
@interface RegisterTableViewController ()<UIAlertViewDelegate>
@property(nonatomic,copy) NSString *username;

@property(nonatomic,copy) NSString *age;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *detail;
@property(nonatomic,copy) NSString *type;
- (IBAction)submit:(id)sender;
@end

@implementation RegisterTableViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.phonenumber=@"01705311326";
    self.password=@"123456";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    if (indexPath.row==0) {
        cell.title.text=@"用户名";
        //如果为空
        if (!self.username) {
            cell.detail.text=@"请设置用户名";
        }else{
            cell.detail.text=self.username;
        }
    }
    if (indexPath.row==1) {
        cell.title.text=@"年龄";
        if (!self.age) {
            cell.detail.text=@"输入年龄";
        }else{
            cell.detail.text=self.age;
        }
    }
    if (indexPath.row==2) {
        cell.title.text=@"性别";
        if (!self.gender) {
            cell.detail.text=@"选择性别";
        }else{
            cell.detail.text=self.gender;
        }
    }

    if (indexPath.row==3) {
        cell.title.text=@"病状";
        if (!self.type) {
            cell.detail.text=@"请输入病状";
        }else{
            cell.detail.text=self.type;
        }
    }
    
    
    if (indexPath.row==4) {
        cell.title.text=@"详情";
        if (!self.detail) {
            cell.detail.text=@"请设置详情";
        }
        cell.detail.text=self.detail;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4&&indexPath.row!=2) {
        RegisterTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        EditViewController *editVC=[storyboard instantiateViewControllerWithIdentifier:@"editVC"];
        if (indexPath.row==1) {
            editVC.isPassword=YES;
            
        }
//        editVC.text=cell.detail.text;
        editVC.navigationItem.title=cell.title.text;
        //block传值
        editVC.selectblock = ^(NSString *string) {
            if (indexPath.row==0) {
                self.username=string;
            }else if (indexPath.row==1){
                self.age=string;
            }else if (indexPath.row==3){
                self.type=string;
            }
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:editVC animated:YES];
        
    }else if (indexPath.row==2){
        RegisterTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        GenderTableViewController *genderVC=[storyboard instantiateViewControllerWithIdentifier:@"genderVC"];
        genderVC.title=cell.title.text;
        //block传值
        genderVC.selectedGenderBlock = ^(NSString *gender) {
            NSLog(@"传过来的gender=%@",gender);
            self.gender=gender;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:genderVC animated:YES];
    }
    else
    {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        RegisterDetailViewController *detailVC=[storyboard instantiateViewControllerWithIdentifier:@"RegisterDetail"];
        detailVC.selectblock = ^(NSString *detail) {
            self.detail=detail;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


//将信息提交到服务器 地址  http://112.74.92.197/patient/submit.php
- (IBAction)submit:(id)sender {
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/patient/submit.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    if(!self.detail){
        self.detail=@"暂未填写";
    }
    NSString *str=[NSString stringWithFormat:@"username=%@&&age=%@&&gender=%@&&type=%@&&phonenumber=%@&&detail=%@",self.username,self.age,self.gender,self.type,self.phonenumber,self.detail];
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *res=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",res);
        if ([res isEqualToString:@"success"]) {
            NSLog(@"注册成功");
            //环信注册
            
            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.phonenumber password:self.password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                NSLog(@"环信注册成功");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功，已为您登陆" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
                alert.delegate=self;
                
               
                
            
                
            } onQueue:nil];
            
        }else{
            NSLog(@"注册失败:%@",error);
        }
        
    }];
    [task resume];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.phonenumber password:self.password completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error && loginInfo) {
                NSLog(@"登录成功");
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                
                
                
                //获取中文名
                NSURLSession *session=[NSURLSession sharedSession];
                NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/patient/MyselfInfo.php"];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                request.HTTPMethod=@"POST";
                NSString *str=[NSString stringWithFormat:@"phonenumber=%@",self.phonenumber];
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
                        
                    });
                    
                    
                    
                    
                }];
                [task resume];
                
                
            }
            
        } onQueue:nil];
    }
   
}

@end
