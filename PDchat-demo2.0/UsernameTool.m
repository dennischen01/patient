//
//  UsernameTool.m
//  PDchat-demo2.0
//
//  Created by 陈希灿 on 2017/4/8.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "UsernameTool.h"


@implementation UsernameTool
- (NSString *)getUsername:(NSString *)phoneNumber andIspatient:(BOOL)isPatient{
    __block NSString *username;
    if (isPatient) {
        NSURL *url=[NSURL URLWithString:@"http://127.0.0.1/server/patient_username.php"];
        NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
        requset.HTTPMethod=@"POST";
        NSString *str=[NSString stringWithFormat:@"phonenumber=%@",phoneNumber];
        requset.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requset delegate:self];
        if (conn) {
            _mResponseData = [[NSMutableData alloc] init];
        }
        
    
    }else{
        NSURL *url=[NSURL URLWithString:@"http://127.0.0.1/server/doctor_username.php"];
        NSURLSession *session=[NSURLSession sharedSession];
        NSMutableURLRequest *requset=[NSMutableURLRequest requestWithURL:url];
        requset.HTTPMethod=@"POST";
        NSString *str=[NSString stringWithFormat:@"phonenumber=%@",phoneNumber];
        requset.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSessionTask *task=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *name=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            username=name;
        }];
        [task resume];
    }
    return self.name;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *name=[[NSString alloc]initWithData:self.mResponseData encoding:NSUTF8StringEncoding];
    self.name=name;
}



@end
