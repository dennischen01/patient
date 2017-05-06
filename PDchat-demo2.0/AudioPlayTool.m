//
//  AudioPlayTool.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/31.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "AudioPlayTool.h"
#import "EMCDDeviceManager.h"
static UIImageView *animatingImageView;
@implementation AudioPlayTool
+ (void)playwithMessage:(EMMessage *)msg msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver{
   //把以前的动画移除
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    NSLog(@"把以前的动画移除");
    //1.语音消息体
    EMVoiceMessageBody *voicebody=msg.messageBodies[0];
    NSLog(@"播放语音");
    //2.本地语音文件路径
    NSString *path=voicebody.localPath;
    //3.如果本地语音文件不存在，则使用服务器语音
    NSFileManager *manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        path=voicebody.remotePath;
    }
    //播放语音
    [[EMCDDeviceManager sharedInstance]asyncPlayingWithPath:path completion:^(NSError *error) {
        NSLog(@"播放完毕%@",error);
        [animatingImageView stopAnimating];
        [animatingImageView removeFromSuperview];
        
    }];
    //4.添加动画
    //创建一个UIImageview,添加到Label上
    UIImageView *imgView=[[UIImageView alloc]init];
    [msgLabel addSubview:imgView];
    NSLog(@"创建一个UIImageview,添加到Label上");
    if (receiver) {
        //添加动画图片
        imgView.animationImages=@[[UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                  [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                  [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                  [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
        imgView.frame=CGRectMake(0, 0, 30, 30);
    }else{
        NSLog(@"添加动画图片");
        imgView.animationImages=@[[UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                  [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                  [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                  [UIImage imageNamed:@"chat_sender_audio_playing_003"]];
        imgView.frame = CGRectMake(msgLabel.bounds.size.width - 30, 0, 30, 30);
    }
    NSLog(@"-----");
    imgView.animationDuration=1;
    [imgView startAnimating];
    animatingImageView=imgView;
     
}


+ (void)stop{
    //停止播放语音
    [[EMCDDeviceManager sharedInstance]stopPlaying];
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
}

@end
