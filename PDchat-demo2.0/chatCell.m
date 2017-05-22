//
//  chatCell.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/28.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "chatCell.h"
#import "EMCDDeviceManager.h"
#import "AudioPlayTool.h"
#import "UIImageView+WebCache.h"
#import "ScanImage.h"

@interface chatCell()
@property (nonatomic,strong)UIImageView *chatImageView;


@end



@implementation chatCell


- (UIImageView *)chatImageView{
    if (!_chatImageView) {
        _chatImageView=[[UIImageView alloc]init];
    }
    return _chatImageView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //初始化
    //1.给label添加敲击手势
    UITapGestureRecognizer *tag=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageLabelTap:)];
    [self.messageLabel addGestureRecognizer:tag];
}

- (void)messageLabelTap:(UITapGestureRecognizer *)recognizer{
    NSLog(@"%s",__func__);
    //播放语音：只有当前的类型为语音时才需要播放
    //获取消息体
    id body=self.message.messageBodies[0];
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {
        NSLog(@"播放语音");
        BOOL receiver=[self.reuseIdentifier isEqualToString:@"ReceiverCell"];
        NSLog(@"%d",receiver);
        [AudioPlayTool playwithMessage:self.message msgLabel:self.messageLabel receiver:receiver];
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *message=body;
        [ScanImage scanBigImageWithImageView:self.chatImageView];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGFloat)cellHeight{
    //1.重新布局子控件
    [self layoutIfNeeded];
    return 5+10+self.messageLabel.bounds.size.height+10+5;
}

- (void)setMessage:(EMMessage *)message{
    //重用是把显示聊天图片的控件移除
    [self.chatImageView removeFromSuperview];
    _message=message;
    id body=message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textbody=body;
        NSString *receivedText=textbody.text;
        NSString *text=[receivedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.messageLabel.text=text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        //语音消息
        //self.messageLabel.text=@"[语音]";
        self.messageLabel.attributedText=[self voiceAtt];
    }else if ([body isKindOfClass:[EMImageMessageBody class]]){
        [self showImage];
    }
    else {
        self.messageLabel.text=@"未知类型";
    }
}

#pragma mark 返回语音富文本
- (NSAttributedString *)voiceAtt{
    //接收方：富文本=图片+时间
    NSMutableAttributedString *voiceAttm=[[NSMutableAttributedString alloc]init];
    if ([self.reuseIdentifier isEqualToString:@"ReceiverCell"]) {
        //1.1接收方的语音图片
        UIImage *receiverImage=[UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        //1.2创建图片附件
        NSTextAttachment *imgAttachment=[[NSTextAttachment alloc]init];
        imgAttachment.image=receiverImage;
        imgAttachment.bounds=CGRectMake(0, -7, 30, 30);
        //1.3图片富文本
        NSAttributedString *imgAtt=[NSAttributedString attributedStringWithAttachment:imgAttachment];
        [voiceAttm appendAttributedString:imgAtt];
        //1.4创建时间富文本
        EMVoiceMessageBody *voiceBody=self.message.messageBodies[0];
        NSInteger duration=voiceBody.duration;
        NSString *timeStr=[NSString stringWithFormat:@"%ld'",duration];
        NSAttributedString *timeAtt=[[NSAttributedString alloc]initWithString:timeStr];
        [voiceAttm appendAttributedString:timeAtt];
    }else{
    //发送方：富文本=时间+图片
        //1.1创建时间富文本
        EMVoiceMessageBody *voiceBody=self.message.messageBodies[0];
        NSInteger duration=voiceBody.duration;
        NSString *timeStr=[NSString stringWithFormat:@"%ld'",duration];
        NSAttributedString *timeAtt=[[NSAttributedString alloc]initWithString:timeStr];
        [voiceAttm appendAttributedString:timeAtt];

        //1.2接收方的语音图片
        UIImage *receiverImage=[UIImage imageNamed:@"chat_sender_audio_playing_full"];
        //1.3创建图片附件
        NSTextAttachment *imgAttachment=[[NSTextAttachment alloc]init];
        imgAttachment.image=receiverImage;
        imgAttachment.bounds=CGRectMake(0, -7, 30, 30);
        //1.4图片富文本
        NSAttributedString *imgAtt=[NSAttributedString attributedStringWithAttachment:imgAttachment];
        [voiceAttm appendAttributedString:imgAtt];
            
    }
        return [voiceAttm copy];
}



- (void)showImage{
    // 获取图片消息体
    EMImageMessageBody *imgBody = self.message.messageBodies[0];
    CGRect thumbnailFrm = (CGRect){0,0,imgBody.thumbnailSize};
    
    // 设置Label的尺寸足够显示UIImageView
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    imgAttach.bounds = thumbnailFrm;
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttach];
    self.messageLabel.attributedText = imgAtt;
    
    //1.cell里添加一个UIImageView
    [self.messageLabel addSubview:self.chatImageView];
    self.chatImageView.backgroundColor = [UIColor redColor];
    
    //2.设置图片控件为缩略图的尺寸
    self.chatImageView.frame = thumbnailFrm;
    
    //3.下载图片
    NSFileManager *manager = [NSFileManager defaultManager];
    // 如果本地图片存在，直接从本地显示图片
    UIImage *palceImg = [UIImage imageNamed:@"1491057757_icons_save"];
    if ([manager fileExistsAtPath:imgBody.thumbnailLocalPath]) {
#warning 本地路径使用fileURLWithPath方法
        [self.chatImageView sd_setImageWithURL:[NSURL fileURLWithPath:imgBody.thumbnailLocalPath] placeholderImage:palceImg];
    }else{
        // 如果本地图片不存，从网络加载图片
        [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:imgBody.thumbnailRemotePath] placeholderImage:palceImg];
    }
    
}

    @end

