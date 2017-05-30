//
//  FullDetailViewController.m
//  patient
//
//  Created by 陈希灿 on 2017/5/30.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "FullDetailViewController.h"

@interface FullDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FullDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets =NO;
        
    }
    // Do any additional setup after loading the view.
    self.textView.text=self.detail;
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
