//
//  AlterTableViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/5/28.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "AlterTableViewController.h"
#import "RegisterTableViewCell.h"
#import "EditViewController.h"
#import "GenderTableViewController.h"
#import "RegisterDetailViewController.h"
#import "EaseMob.h"
@interface AlterTableViewController ()

@property(nonatomic,copy) NSString *phonenumber;
@property(nonatomic,copy) NSString *username;

@property(nonatomic,copy) NSString *age;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *detail;
@property(nonatomic,copy) NSString *type;
- (IBAction)save:(id)sender;

@end

@implementation AlterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改个人信息";
    
    self.phonenumber= [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSDictionary *dit=[def objectForKey:@"selfinfo"];
    self.username=[dit objectForKey:@"username"];
    
    self.age=[dit objectForKey:@"age"];
    self.gender=[dit objectForKey:@"gender"];
    self.detail=[dit objectForKey:@"detail"];
    self.type=[dit objectForKey:@"type"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"用户名";
        //如果为空
        if (!self.username) {
            cell.detailTextLabel.text=@"请设置用户名";
        }else{
            cell.detailTextLabel.text=self.username;
        }
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"年龄";
        if (!self.age) {
            cell.detailTextLabel.text=@"输入年龄";
        }else{
            cell.detailTextLabel.text=self.age;
        }
    }
    if (indexPath.row==2) {
        cell.textLabel.text=@"性别";
        if (!self.gender) {
            cell.detailTextLabel.text=@"选择性别";
        }else{
            cell.detailTextLabel.text=self.gender;
        }
    }
    
    if (indexPath.row==3) {
        cell.textLabel.text=@"病状";
        if (!self.type) {
            cell.detailTextLabel.text=@"请输入病状";
        }else{
            cell.detailTextLabel.text=self.type;
        }
    }
    
    
    if (indexPath.row==4) {
        cell.textLabel.text=@"详情";
        if (!self.detail) {
            cell.detailTextLabel.text=@"请设置详情";
        }
        cell.detailTextLabel.text=self.detail;
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
        editVC.navigationItem.title=cell.textLabel.text;
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
- (IBAction)save:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSession *session=[NSURLSession sharedSession];
        NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/patient/updateInfo.php"];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        NSString *str=[NSString stringWithFormat:@"username=%@&&age=%@&&gender=%@&&type=%@&&detail=%@&&phonenumber=%@",self.username,self.age,self.gender,self.type,self.detail,self.phonenumber];
        
        NSLog(@"请求体：%@",str);
        request.HTTPMethod=@"POST";
        request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *res=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"res=%@",res);
            if (res) {
                NSLog(@"修改成功");
                NSDictionary *dit=[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"username",self.username,
                                   @"age",self.age,
                                   @"gender",self.gender,
                                   @"type",self.type,
                                   @"detail",self.detail
                                   , nil];
                
                
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:dit forKey:@"selfinfo"];
            }
            
        }];
        [task resume];
    });
}
@end
