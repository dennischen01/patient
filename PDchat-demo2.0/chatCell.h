//
//  chatCell.h
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/3/28.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *senderImageView;

- (CGFloat)cellHeight;
@property(nonatomic,strong)EMMessage *message;
@end
