//
//  GenderTableViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/4/18.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "GenderTableViewController.h"

@interface GenderTableViewController ()
@end

@implementation GenderTableViewController
- (IBAction)finish:(id)sender {
    if (self.selectedGenderBlock) {
        self.selectedGenderBlock(self.selectedGender);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


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





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    self.selectedGender=cell.textLabel.text;
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
}



@end
