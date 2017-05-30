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
#import "doctor.h"
#import "MJRefresh.h"
@interface MessageTableViewController ()<EMChatManagerDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSString *buddyusername;
/** 历史会话记录 */
@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic, strong) NSMutableArray *dates;
//所有患者
@property (nonatomic, strong) NSMutableArray *doctor;
@property (nonatomic, strong) NSArray *arr;
//会话列表的患者数据源
@property (nonatomic, strong) NSMutableArray *datasourses;
@property NSDictionary *dic;

@end

@implementation MessageTableViewController
- (NSMutableArray *)conversations{
    if (!_conversations) {
        _conversations=[NSMutableArray array];
    }
    return _conversations;
}
- (NSMutableArray *)dates{
    if (!_dates) {
        _dates=[NSMutableArray array];
    }
    return _dates;
}

- (NSMutableArray *)doctor{
    if (!_doctor) {
        _doctor=[NSMutableArray array];
    }
    
    return _doctor;
}
- (NSMutableArray *)datasourses{
    if (!_datasourses) {
        _datasourses=[NSMutableArray array];
    }
    return _datasourses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //获取历史绘画记录
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    [self addname];
    [self setTableFooterView:self.tableView];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.arr=[defaults objectForKey:@"total"];
    /*
    for (NSData *data in self.arr) {
        doctor *d=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.doctor addObject:d];
    }
    */
    
//    [self addNameFromLocal];
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addname)];
    [self.tableView.mj_header beginRefreshing];
    
     
}

- (void)myrelaodmethod{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
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


- (void)addNameFromLocal{
    for (EMConversation *conversation in self.conversations) {
        NSString *phonenumber=conversation.chatter;
        for (doctor *d in self.doctor) {
            NSString *phone=d.phonenumber;
            if ([phone isEqualToString:phonenumber]) {
                [self.datasourses addObject:d];
            }
        }
    }
    
}

- (void)addNameFromConversation:(EMConversation *)conversation{
    NSString *phonenumber=conversation.chatter;
    for (doctor *d in self.doctor) {
        NSString *phone=d.phonenumber;
        if ([phone isEqualToString:phonenumber]) {
            [self.datasourses addObject:d];
        }
        
    }
}

- (void)addname{
    //遍历
    
    //网络请求获取用户名 patient_getInfo.php get请求
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://112.74.92.197/doctor/getAllInfo.php"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //如果不是好友，就加入到显示列表中
        
        
        self.dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (id obj in self.dic) {
            
            doctor *d=[[doctor alloc]initWithUsername:obj[@"username"]
                                               andAge:obj[@"age"]
                                              andType:obj[@"type"]
                                            andGender:obj[@"gender"]
                                       andPhonenumber:obj[@"phonenumber"]
                                            andDetail:obj[@"detail"]
                                          andImageurl:obj[@"imageurl"]
                                          andHospital:obj[@"hospital"]
                       ];
            [self.doctor addObject:d];
            NSLog(@"线程=%@",[NSThread currentThread]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addNameFromLocal];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    [task resume];
}



- (void)loadConversations{
    //获取历史会话记录
    //1.从内存获取历史会话记录
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    //2.如果内存里没有会话记录，从数据库Conversation表
    if (conversations.count == 0) {
        conversations =  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    self.conversations=[NSMutableArray array];
    [self.conversations addObjectsFromArray:conversations];
}

#pragma mark 未读消息数改变
- (void)didUnreadMessagesCountChanged{
    //更新表格
    NSLog(@"更新表格");
    self.conversations=  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.tableView reloadData];
    //显示总的未读数
    [self showTabBarBadge];
    
    
}


#pragma mark 历史会话列表更新

- (void)didUpdateConversationList:(NSArray *)conversationList{
    
    NSLog(@"历史会话列表更新");
    //给数据源重新赋值
    for (EMConversation *obj in conversationList) {
        if (![self.conversations containsObject:obj]) {
            [self.conversations addObject:obj];
            [self addNameFromConversation:obj];
            
        }
        
    }
    
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
    }else{
        self.navigationController.tabBarItem.badgeValue=nil;
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
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"患者添加请求" message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static const int imgTag = 111;
    static const int labelTag = 222;
    static const int messageTag = 333;
    UIImageView *imageView = nil;
    UILabel *textLabel = nil;
    UILabel *messageLabel = nil;
    static NSString *ID =  @"ConversationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    for (UIView *v in cell.contentView.subviews) {
        switch (v.tag) {
            case imgTag:imageView = v;break;
            case labelTag:textLabel = v;break;
            case messageTag:messageLabel = v;break;
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
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 30)];
        [textLabel setFont:[UIFont systemFontOfSize:22]];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = labelTag;
        [cell.contentView addSubview:textLabel];
    }
    
    if (messageLabel == nil) {
        CGFloat messageWidth = [UIScreen mainScreen].bounds.size.width - 130;
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, messageWidth, 20)];
        [messageLabel  setFont:[UIFont systemFontOfSize:16]];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.text = @"作为医生我觉得你没必要抢救了";
        messageLabel.tag = messageTag;
        [cell.contentView addSubview:messageLabel];
    }
    
    //1.获取会话模型
    NSLog(@"datasouces=%d conversatin=%d",self.datasourses.count,self.conversations.count);
    EMConversation *conversaion = self.conversations[indexPath.row];
    if (self.datasourses.count==self.conversations.count) {
        doctor *d=self.datasourses[indexPath.row];
        textLabel.text=d.username;
        NSString *imageurl=d.imageurl;
        NSURL *url=[NSURL URLWithString:imageurl];
        NSLog(@"imageurl=%@",imageurl);
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        
        // 2.显示最新的一条记录
        // 获取消息体
        id body = conversaion.latestMessage.messageBodies[0];
        //文字消息
        if ([body isKindOfClass:[EMTextMessageBody class]]) {
            EMTextMessageBody *textBody = body;
            messageLabel.text = textBody.text;
            //语音消息
        }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
            EMVoiceMessageBody *voiceBody = body;
            messageLabel.text = [voiceBody displayName];
            //图片消息
        }else if([body isKindOfClass:[EMImageMessageBody class]]){
            EMImageMessageBody *imgBody = body;
            messageLabel.text = [imgBody displayName];
        }else{
            messageLabel.text = @"未知消息类型";
        }
    }
    EMMessage *message=conversaion.latestMessage;
    NSLog(@"message=%@",message);
    long long time=message.timestamp;
    
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"HH:mm";
    NSString *timeStr=[formatter stringFromDate:msgDate];
    NSLog(@"timestr=%@",timeStr);
    cell.detailTextLabel.text =timeStr;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_conversations.count == 0) {
        return;
    }
    //进入到聊天控制器
    //1.从storybaord加载聊天控制器
    chatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPage"];
    //会话
    EMConversation *conversation = self.conversations[indexPath.row];
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    doctor *d=self.datasourses[indexPath.row];
    
    NSString *imageurl=d.imageurl;
    
    //2.设置好友属性
    chatVc.buddy = buddy;
    chatVc.title=d.username;
    chatVc.imageurl=imageurl;
    //3.展现聊天界面
    
    
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        
        
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
        NSLog(@"选择的chatter=%@",chatter);
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        
        [self.conversations removeObjectAtIndex:indexPath.row];
        [self.datasourses removeObjectAtIndex:indexPath.row];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView reloadData];
        NSLog(@"successfully delete");
    }
    
    
}


//- (void)didRemovedByBuddy:(NSString *)username{
//    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:NO append2Chat:YES];
//
//    for (EMConversation *conversation in self.conversations) {
//        if (conversation.chatter==username) {
//            [self.conversations removeObject:conversation];
//        }
//    }
//    for (patient *p in self.datasourses) {
//        if (p.username==username) {
//            [self.datasourses removeObject:p];
//        }
//    }
//
//}

- (void)delayMethod {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
}


@end
