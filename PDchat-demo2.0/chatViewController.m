//
//  chatViewController.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/28.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "chatViewController.h"
#import "chatCell.h"
#import "EaseMob.h"
#import "EMCDDeviceManager.h"
#import "AudioPlayTool.h"
#import "TimeCell.h"
#import "TimeTool.h"
#import "MessageTableViewController.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
@interface chatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EMChatManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *receiverImage;
//输入工具条底部约束
@property (weak, nonatomic) IBOutlet UIImageView *sendImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstrain;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong,nonatomic) NSMutableArray *dataSourse;
@property (weak, nonatomic) IBOutlet UITableView *tablevIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToolbarConstraint;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;


@property NSString *friendname;
@property NSString *friendphonenumber;
@property NSString *friendage;
@property NSString *friendhospital;
@property NSString *friendtype;
@property NSString *frienddetail;


/** 当前添加的时间 */
@property (nonatomic, copy) NSString *currentTimeStr;


//计算高度的cell
@property (nonatomic,strong)chatCell *chatCellTool;


/** 当前会话对象 */
@property (nonatomic, strong) EMConversation *conversation;
@end

@implementation chatViewController


- (NSMutableArray *)dataSourse{
    if (!_dataSourse) {
        _dataSourse=[NSMutableArray array];
    }
    return _dataSourse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.tablevIew.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0  blue:246/255.0  alpha:0];
    self.tablevIew.frame=CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.width-66);
    
    //给计算高度的cell对象赋值
    self.chatCellTool=[self.tablevIew dequeueReusableCellWithIdentifier:receiverCell];
    
    //加载本地数据库的聊天记录
    [self locdLoadLocalChatRecord];
    [self scrollToBottom];
    NSLog(@"%d",self.dataSourse.count);
    
    //设置聊天管理器的daili
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //1.监听键盘弹出,把inputToolBar往上移
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //2.监听键盘退出，inputToolbar恢复原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}



#pragma mark 键盘显示是调用的方法
- (void)kbWillShow:(NSNotification *)noti{
    if (self.dataSourse.count<10) {
        return;
    }else{
  
    
        //滑动效果（动画）
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        
        self.view.frame = CGRectMake(0.0f, -152.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
        
        [UIView commitAnimations];
        
        
        //1.获取键盘高度
        CGRect kbEndFram=[noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
        CGFloat kbHeight=kbEndFram.size.height;
        
        
        //2.更改约束
        self.inputViewBottomConstrain.constant=kbHeight-152;
        
        //添加动画
        [UIView animateWithDuration:0.1 animations:^{
            [self.view layoutIfNeeded];
        }];}

    
    
    
    
    

    
}

#pragma mark 键盘退出时会触发的方法
-(void)kbWillHide:(NSNotification *)noti{
    //inputToolbar恢复原位
    self.inputViewBottomConstrain.constant = 0;
    
    
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 表格数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //时间cell的高度是固定
    if ([self.dataSourse[indexPath.row] isKindOfClass:[NSString class]]) {
        return 18;
    }

    
    EMMessage *msg=self.dataSourse[indexPath.row];
    self.chatCellTool.message=msg;
    return self.chatCellTool.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //显示内容
    /*
     *EMMessage有from和to两个属性
     from:自己
     
     
     */
    
    //
    //判断数据源类型
    if ([self.dataSourse[indexPath.row] isKindOfClass:[NSString class]]) {//显示时间cell
        TimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        timeCell.timeLabel.text = self.dataSourse[indexPath.row];
        return timeCell;
        
    }

    
    
    //1.先获取消息模型
    EMMessage *message=self.dataSourse[indexPath.row];
    chatCell *cell = nil;
    
    UITapGestureRecognizer *receiverTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ReceivergestureTapEvent:)];
    
    UITapGestureRecognizer *senderTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendergestureTapEvent:)];
    
    if ([message.from isEqualToString:self.buddy.username]) {//接收方
        cell = [tableView dequeueReusableCellWithIdentifier:receiverCell];
        [cell.receiverImageView addGestureRecognizer:receiverTapGesture];
        NSLog(@"传过来的imageurl%@",self.imageurl);
        [cell.receiverImageView sd_setImageWithURL:self.imageurl placeholderImage:[UIImage imageNamed:@"ali"]];
    }else{//发送方
        cell = [tableView dequeueReusableCellWithIdentifier:senderCell];
        [cell.senderImageView addGestureRecognizer:senderTapGesture];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *infodit=[defaults objectForKey:@"selfinfo"];
        
        NSString *imageurl=[infodit objectForKey:@"imageurl"];
        NSLog(@"发送方imageurl=%@",imageurl);
        [cell.senderImageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"ali"]];
    }
    cell.message=message;
    return cell;
}

- (void)ReceivergestureTapEvent:(UITapGestureRecognizer *)gesture {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC=[storyboard instantiateViewControllerWithIdentifier:@"frienddetail"];
    detailVC.phonenumber=self.buddy.username;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)SendergestureTapEvent:(UITapGestureRecognizer *)gesture {
    
}

#pragma mark UITextView代理
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",NSStringFromCGSize(textView.contentSize));
    //计算textview的高度，调整整个inputtoolbar的高度
    CGFloat textViewH=0;
    CGFloat minHeight=33;
    CGFloat maxHeight=68;
    //获取contensize的高度
    CGFloat contentHeight=textView.contentSize.height;
    if (contentHeight<minHeight) {
        textViewH=minHeight;
    }else if (contentHeight>maxHeight) {
        textViewH=maxHeight;
    }else{
        textViewH=contentHeight;
    }
   
    
    //监听send事件--判断最后的一个字符是不是换行字符
    if ([textView.text hasSuffix:@"\n"]) {
        NSLog(@"发送");
        [self sendMessage:textView.text];
        //清空textView
        textView.text=nil;
        textViewH=minHeight;
    }
    
    
    //调整toolbar高度约束
    self.inputToolbarConstraint.constant=6+7+textViewH;
    
    // 加个动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
    // 4.记光标回到原位
#warning 技巧
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
    
    
    
}

- (void)sendMessage:(NSString *)text{
    //创建一个聊天文本
    EMChatText *chatText=[[EMChatText alloc]initWithText:text];
    //创建一个消息体
    EMTextMessageBody *textbody=[[EMTextMessageBody alloc]initWithChatObject:chatText];
    //1.创建一个消息对象
    EMMessage *msg=[[EMMessage alloc]initWithReceiver:self.buddy.username bodies:@[textbody]];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    NSLog(@"发送成功");
    [self addDataSourcesWithMessage:msg];
    [self.tablevIew reloadData];
    [self scrollToBottom];
}

- (void)sendVoice:(NSString *)recordPath duration:(NSInteger)duration{
    //1.构造一个语音的消息体
    EMChatVoice *voice=[[EMChatVoice alloc]initWithFile:recordPath displayName:@"[语音]"];
    EMVoiceMessageBody *voiceBody=[[EMVoiceMessageBody alloc]initWithChatObject:voice];
    voiceBody.duration=duration;
    //2.构造一个消息对象
    EMMessage *msgobj=[[EMMessage alloc]initWithReceiver:self.buddy.username bodies:@[voiceBody]];
    msgobj.messageType=eMessageTypeChat;
    //3.发送
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgobj progress:nil];
    NSLog(@"语音发送成功");
    [self addDataSourcesWithMessage:msgobj];
    [self.tablevIew reloadData];
    [self scrollToBottom];

}

- (void)sendImage:(UIImage *)image{
    //1.构造图片消息体
    //第一个参数:原始大小的图片对象
    //第二个参数:缩略图的图片对象
    EMChatImage *originalChatImg=[[EMChatImage alloc]initWithUIImage:image displayName:@"[图片]"];
    EMImageMessageBody *imgBody=[[EMImageMessageBody alloc]initWithImage:originalChatImg thumbnailImage:nil];
    //2.构造消息对象
    EMMessage *msgObj=[[EMMessage alloc]initWithReceiver:self.buddy.username bodies:@[imgBody]];
    msgObj.messageType=eMessageTypeChat;
    //3.发送图片
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj progress:nil];
    [self addDataSourcesWithMessage:msgObj];
    [self.tablevIew reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom{
    NSLog(@"num=%d",self.dataSourse.count);
    //1.获取最后一行
    if (self.dataSourse.count == 0) {
        return;
    }
    
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.dataSourse.count-1 inSection:0];
    
    [self.tablevIew scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)locdLoadLocalChatRecord{
    //假设在数组的第一位置添加时间
//    [self.dataSourse addObject:@"16:06"];
    
    //要获取本地的聊天记录，使用回话对象
    EMConversation *conversation=[[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    self.conversation=conversation;
    //加载与当前聊天用户所有的聊天记录
    NSArray *message=[conversation loadAllMessages];
    NSLog(@"%@",message);
    //添加到数据源
    for (EMMessage *msgObj in message) {
        [self addDataSourcesWithMessage:msgObj];
    }
}

#pragma mark 接收好友的回复消息
- (void)didReceiveMessage:(EMMessage *)message{
    if ([message.from isEqualToString:self.buddy.username]) {//判断是不是来自当前聊天用户 
        //1.把接收到的消息放到数据源
        [self addDataSourcesWithMessage:message];
        //2.刷新表格
        [self.tablevIew reloadData];
        //3.滑动到底部
        [self scrollToBottom];
    }
    
}

- (IBAction)voiceAction:(id)sender {
    // 1.显示录音按钮
    self.recordBtn.hidden = !self.recordBtn.hidden;
    self.textView.hidden = !self.textView.hidden;
    
    if (self.recordBtn.hidden == NO) {//录音按钮要显示
        //InputToolBar 的高度要回来默认(46);
        self.inputToolbarConstraint.constant = 46;
        // 隐藏键盘
        [self.view endEditing:YES];
    }else{
        //当不录音的时候，键盘显示
        [self.textView becomeFirstResponder];
        
        // 恢复InputToolBar高度
        [self textViewDidChange:self.textView];
    }

}


#pragma mark 语音功能
- (IBAction)beginRecordAction:(id)sender {
    // 文件名以时间命名
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    [[EMCDDeviceManager sharedInstance]asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"开始录音");
        }
    }];
}

- (IBAction)endRecordAction:(id)sender {
    [[EMCDDeviceManager sharedInstance]asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"录音成功");
            NSLog(@"%@",recordPath);
            [self sendVoice:recordPath duration:aDuration];
        }
    }];
}
- (IBAction)cancelRecordAction:(id)sender {
    [[EMCDDeviceManager sharedInstance]cancelCurrentRecording];
}
- (IBAction)showImagePicker:(id)sender {
    //显示图片选择的控制器
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    //设置元
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate=self;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
#pragma mark 选中图片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //1.获取用户选中的图片
    UIImage *selectedImage=info[UIImagePickerControllerOriginalImage];
    //2.发送图片
    [self sendImage:selectedImage];
    //3.隐藏当前图片选中控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止语音播放
    [AudioPlayTool stop];
}


-(void)addDataSourcesWithMessage:(EMMessage *)msg{
    // 1.判断EMMessage对象前面是否要加 "时间"
    //    if (self.dataSources.count == 0) {
    ////        long long timestamp = ([[NSDate date] timeIntervalSince1970] - 60 * 60 * 24 * 2) * 1000;
    //
    //    }
    
    NSString *timeStr = [TimeTool timeStr:msg.timestamp];
    if (![self.currentTimeStr isEqualToString:timeStr]) {
        [self.dataSourse addObject:timeStr];
        self.currentTimeStr = timeStr;
    }
    
    
    
    
    // 2.再加EMMessage
    [self.dataSourse addObject:msg];
    
    // 3.设置消息为已读取
    [self.conversation markMessageWithId:msg.messageId asRead:YES];
    
    
}


#pragma mark - 屏幕上弹
-( void )textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
-( void )textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}







@end
