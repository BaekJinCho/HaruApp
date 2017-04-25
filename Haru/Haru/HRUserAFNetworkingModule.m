//
//  HRUserAFNetworkingModule.m
//  Haru
//
//  Created by SSangGA on 2017. 4. 7..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRUserAFNetworkingModule.h"
#import <AFNetworking/AFNetworking.h>
#import "HRNetworkModule.h"
#import "HRConstantKeys.h"

@interface HRUserAFNetworkingModule ()
@property (nonatomic) AFHTTPSessionManager *manager;
@property (nonatomic) HRNetworkModule *networkModule;

@end

@implementation HRUserAFNetworkingModule

//UserID요청하는 메소드
- (void)getUserProfile:(CompletionBlock)completion 
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL2, USER_URL];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken] forHTTPHeaderField:TOKEN_KEY];
    NSLog(@"url = %@",url);    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(YES, responseObject);
        NSLog(@"UserID RESPONSE:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"UserID ERROR:%@", error);
    }];
}

//postlist요청하는 메소드
- (void)postListRequest:(NSString *)token completion
                       :(CompletionBlock)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, POST_URL];
    NSString *url = [NSString stringWithFormat:@"https://haru.ycsinabro.com/post/"];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken] forHTTPHeaderField:TOKEN_KEY];
    NSString *tokenValue = [NSString stringWithFormat:@"%@",[HRDataCenter sharedInstance].userToken];
    NSLog(@"tokenValue = %@",tokenValue);
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POSTLIST DATA:%@", responseObject);
        completion(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POSTLIST ERROR:%@", error);
        completion(NO,nil);
    }];
}

//프로파일 이미지 요청 메소드
//- (void)profileImageRequest:(NSString)
@end
