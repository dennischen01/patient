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

@end

@implementation AlterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
@end
