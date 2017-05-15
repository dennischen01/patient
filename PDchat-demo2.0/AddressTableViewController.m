//
//  AddressTableViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/26.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "AddressTableViewController.h"
#import "EaseMob.h"
#import "chatViewController.h"
#import "AddFriendTableViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface AddressTableViewController ()<EMChatManagerDelegate>
//好友列表数据源
@property (nonatomic,strong) NSArray *buddyList;
@property NSMutableArray *buddyName;
@property NSMutableArray *usernames;
//保存图片url
@property NSMutableArray *images;
- (IBAction)addBtn:(id)sender;


@end

@implementation AddressTableViewController

- (NSMutableArray *)buddyName{
    if (!_buddyName) {
        _buddyName=[NSMutableArray array];
    }
    return _buddyName;
}

- (NSMutableArray *)usernames{
    if (!_usernames) {
        _usernames=[NSMutableArray array];
    }
    return _usernames;
}

- (NSMutableArray *)images{
    if (!_images) {
        _images=[NSMutableArray array];
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加聊天管理器的daili
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // 获取好友列表数据
    /* 注意
     * 1.好友列表buddyList需要在自动登录成功后才有值
     * 2.buddyList的数据是从 本地数据库获取
     * 3.如果要从服务器获取好友列表 调用chatManger下面的方法
     【-(void *)asyncFetchBuddyListWithCompletion:onQueue:】;
     * 4.如果当前有添加好友请求，环信的SDK内部会往数据库的buddy表添加好友记录
     * 5.如果程序删除或者用户第一次登录，buddyList表是没记录，
     解决方案
     1》要从服务器获取好友列表记录
     2》用户第一次登录后，自动从服务器获取好友列表
     */
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在加载好友列表";
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        // 赋值数据源
        self.buddyList = buddyList;
//        NSLog(@"从服务器获取的好友列表 %@",buddyList);
//        NSLog(@"有%d个好友",self.buddyList.count);
        
        [self addUsername];
        
        
    }onQueue:nil];
     
#warning 好友列表BuddyList需要在自动登录后才有值
#warning 强调buddyList没有值的情况 1.第一次登录 2.自动登录还没有完成
    
    [self setTableFooterView:self.tableView];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
    
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

- (void) addUsername{
    //1.创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    for (EMBuddy *buddy in self.buddyList) {
        //2.等待-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/doctor/usernameAndImage.php"];
        NSURLSession *session=[NSURLSession sharedSession];
        NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
        requset.HTTPMethod=@"POST";
        NSString *str=[NSString stringWithFormat:@"phonenumber=%@",buddy.username];
        requset.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSessionTask *task=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //3 +1
                dispatch_semaphore_signal(semaphore);
                
                NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"obj=%@",obj);
                
                NSString *name=[obj objectForKey:@"name"];
                NSString *imageurl=[obj objectForKey:@"image"];
                [self.usernames addObject:name];
                [self.images addObject:imageurl];
                if (![self.buddyName containsObject:name]) {
                    [self.buddyName addObject:name];
                }
                [self.tableView reloadData];
                
            });
            
            
        }];
        [task resume];

    }
    
  
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static const int imgTag = 111;
    static const int labelTag = 222;
    UIImageView *imageView = nil;
    UILabel *textLabel = nil;
    
    
    static NSString *id=@"BuddyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    // Configure the cell...
    //1.获取好友模型
    EMBuddy *buddy=self.buddyList[indexPath.row];
    //2.显示头像和名称
    
    for (UIView *v in cell.contentView.subviews) {
        switch (v.tag) {
            case imgTag:imageView = v;break;
            case labelTag:textLabel = v;break;
            default:break;
        }
    }
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.image=[UIImage imageNamed:@"chatListCellHead"];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds  = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = imgTag;
        [cell.contentView addSubview:imageView];
    }
    
    if (textLabel == nil) {
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200, cell.contentView.frame.size.height - 40)];
        [textLabel setFont:[UIFont systemFontOfSize:22]];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = labelTag;
        [cell.contentView addSubview:textLabel];
    }
    
    //3.显示名称
    if (self.usernames.count==self.buddyList.count) {
        textLabel.text=self.usernames[indexPath.row];
        NSString *imageurl=self.images[indexPath.row];
        NSURL *url=[NSURL URLWithString:imageurl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
   }
   
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathP{
    return 80;
}
#pragma mark chatmanager的代理方法
#pragma mark 监听自动登录成功
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        self.buddyList=[[EaseMob sharedInstance].chatManager buddyList];
        [self.tableView reloadData];
    }

}



#pragma mark 好友添加请求同意
-(void)didAcceptedByBuddy:(NSString *)username{
    // 把新的好友显示到表格
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"好友添加请求同意 %@",buddyList);
#warning buddyList的个数，仍然是没有添加好友之前的个数，从新服务器获取
    [self loadBuddyListFromServer];
    
    
}
#pragma mark 从新服务器获取好友列表
-(void)loadBuddyListFromServer{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
//        NSLog(@"从服务器获取的好友列表 %@",buddyList);
        
        // 赋值数据源
        self.buddyList = buddyList;
        
        // 刷新
        [self.tableView reloadData];
        
    } onQueue:nil];
}



#pragma mark 好友列表数据被更新
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
//    NSLog(@"好友列表数据被更新 %@",buddyList);
    //重新赋值数据源
    self.buddyList=buddyList;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //获取移除好友的名字
        EMBuddy *buddy=self.buddyList[indexPath.row];
        NSString *removedUsername=buddy.username;
        //删除好友
        [[EaseMob sharedInstance].chatManager removeBuddy:removedUsername removeFromRemote:YES error:nil];
    }
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    //往聊天控制器传递一个Buddy的值
//    id destinationVC=segue.destinationViewController;
//    if ([destinationVC isKindOfClass:[chatViewController class]]) {
//        //获取点击的行
//        NSInteger selectedRow=[self.tableView indexPathForSelectedRow].row;
//        chatViewController *chatVC=destinationVC;
//        chatVC.buddy=self.buddyList[selectedRow];
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_buddyList.count == 0 || _usernames.count == 0 || _images.count == 0) {
        return;
    }
    //进入到聊天控制器
    //1.从storybaord加载聊天控制器
    chatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPage"];

    //2.设置好友属性
    chatVc.buddy = self.buddyList[indexPath.row];
    chatVc.title=self.usernames[indexPath.row];
    chatVc.imageurl=self.images[indexPath.row];
    //3.展现聊天界面
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}

- (void)didRemovedByBuddy:(NSString *)username{
    //刷新表格
    [self loadBuddyListFromServer];
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}

- (IBAction)addBtn:(id)sender {
    AddFriendTableViewController *addVC=[[AddFriendTableViewController alloc]init];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addVC=[storyboard instantiateViewControllerWithIdentifier:@"ADC"];
    addVC.DoctorList=self.buddyName;
    NSLog(@"%@",self.buddyName);
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)delayMethod {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
