//
//  MessageTableViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/26.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "MessageTableViewController.h"
#import "EaseMob.h"
#import "chatViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface MessageTableViewController ()<EMChatManagerDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSString *buddyusername;
/** 历史会话记录 */
@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic, strong) NSMutableArray *usernames;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation MessageTableViewController
- (NSMutableArray *)conversations{
    if (!_conversations) {
        _conversations=[NSMutableArray array];
    }
    return _conversations;
}
- (NSMutableArray *)usernames{
    if (!_usernames) {
        _usernames=[NSMutableArray array];
    }
    return _usernames;
}

- (NSMutableArray *)dates{
    if (!_dates) {
        _dates=[NSMutableArray array];
    }
    return _dates;
}
- (NSMutableArray *)images{
    if (!_images) {
        _images=[NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //获取历史绘画记录
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadConversations];
    [self addname];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setTableFooterView:self.tableView];
}


//消除横线
- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

- (void)addname{
    //遍历
    
    //1.创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    for (EMConversation *conversation in self.conversations) {
        //2.等待-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSString *str=[NSString stringWithFormat:@"phonenumber=%@",conversation.chatter];
        NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/server/doctor_usernameAndImage.php"];
        NSURLSession *session=[NSURLSession sharedSession];
        NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
        requset.HTTPMethod=@"POST";
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
                [self.tableView reloadData];
                
            });
            
            
        }];
        [task resume];
      
    }
   
}



- (void)loadConversations{
    //获取历史会话记录
    //1.从内存获取历史会话记录
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    //2.如果内存里没有会话记录，从数据库Conversation表
    if (conversations.count == 0) {
        NSLog(@"内存中没有会话记录");
        conversations =  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    
    self.conversations=[NSMutableArray array];
    [self.conversations addObjectsFromArray:conversations];
    //显示总的未读数
    [self showTabBarBadge];
    
}

#pragma mark 未读消息数改变
- (void)didUnreadMessagesCountChanged{
    //更新表格
    NSLog(@"更新表格");
    [self.tableView reloadData];
    //显示总的未读数
    [self showTabBarBadge];
    
}


#pragma mark 历史会话列表更新
-(void)didUpdateConversationList:(NSArray *)conversationList{

    //给数据源重新赋值
    for (id obj in conversationList) {
        if (![self.conversations containsObject:obj]) {
            [self.conversations addObject:obj];
        }
    } //刷新表格
    [self.tableView reloadData];

    //显示总的未读数
    [self showTabBarBadge];

}

-(void)showTabBarBadge{
    //遍历所有的会话记录，将未读取的消息数进行累
    
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    if (totalUnreadCount>0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
    }
    
    
}
#pragma mark chatmanager代理方法
//1.监听网络状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    if (connectionState==eEMConnectionDisconnected) {
        NSLog(@"网络断开");
        self.title=@"未连接";
    }else{
        NSLog(@"连接成功");
    }
    
}

- (void)willAutoReconnect{
    NSLog(@"将自动重连接");
    self.title=@"连接中";
}

#pragma mark 好友添加的代理方法
- (void)didAcceptedByBuddy:(NSString *)username{
    NSString *message=[NSString stringWithFormat:@"%@ 同意了你的好友添加请求",username];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)didRejectedByBuddy:(NSString *)username{
    NSString *message=[NSString stringWithFormat:@"%@ 拒绝了你的好友添加请求",username];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSLog(@"自动重连接成功");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 接收好友的添加请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    self.buddyusername=username;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"好友添加请求" message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//拒绝好友请求
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.buddyusername reason:@"太丑了" error:nil];
    }else{//接收好友请求
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.buddyusername error:nil];
        
    }
}


- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.conversations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID =  @"ConversationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.imageView.image=[UIImage imageNamed:@"chatListCellHead"];
    //获取会话模型
    EMConversation *conversaion = self.conversations[indexPath.row];
    if (self.usernames.count==self.conversations.count) {
        cell.textLabel.text=self.usernames[indexPath.row];
        NSString *imageurl=self.images[indexPath.row];
        NSURL *url=[NSURL URLWithString:imageurl];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    }
    EMMessage *message=conversaion.latestMessage;
    long long time=message.timestamp;
    
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"HH:mm";
    NSString *timeStr=[formatter stringFromDate:msgDate];
    cell.detailTextLabel.text =timeStr;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到聊天控制器
    //1.从storybaord加载聊天控制器
    chatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPage"];
    //会话
    EMConversation *conversation = self.conversations[indexPath.row];
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    //2.设置好友属性
    chatVc.buddy = buddy;
    chatVc.title=self.usernames[indexPath.row];
    //3.展现聊天界面
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     if (editingStyle==UITableViewCellEditingStyleDelete) {
        
         
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         NSLog(@"successfully delete");
         
         /*!
          @method
          @brief 删除某个会话对象
          @param chatter 这个会话对象所对应的用户名
          @param aDeleteMessages 是否删除这个会话对象所关联的聊天记录
          @discussion
          直接从数据库中删除,并不会返回相关回调方法;
          若希望返回相关回调方法,请使用removeConversationByChatters:deleteMessages:append2Chat:
          @result 删除成功或失败
          */
         //会话
         EMConversation *conversation = self.conversations[indexPath.row];
         EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
         NSString *chatter=buddy.username;
         [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:YES];
          [self.conversations removeObjectAtIndex:indexPath.row];
     }
    
}


@end
