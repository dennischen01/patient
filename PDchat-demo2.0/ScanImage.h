//
//  ScanImage.h
//  doctor
//
//  Created by 陈希灿 on 2017/4/23.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ScanImage : NSObject
/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;
@end
