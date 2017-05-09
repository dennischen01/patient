//
//  RegisterDetailViewController.m
//  doctor
//
//  Created by 陈希灿 on 2017/4/20.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "RegisterDetailViewController.h"

@interface RegisterDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property NSString *selectedString;

@end

@implementation RegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets =NO;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    self.selectedString=self.textview.text;
    if(self.selectblock){
        self.selectblock(self.selectedString);
    }
    [self.navigationController popViewControllerAnimated:YES];

    
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
