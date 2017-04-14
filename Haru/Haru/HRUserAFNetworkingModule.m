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

//AFHTTPSessionManager에 manager 메소드 및 serializer초기화 override
- (instancetype)initWithAFHTTPSessionManager
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

//AFHTTPSession manager 초기화 메소드
- (id)AFHTTPManager
{
    HRUserAFNetworkingModule *manager = [[HRUserAFNetworkingModule alloc]initWithAFHTTPSessionManager];
    return manager;
}

//login 메소드
- (void)loginRequest:(NSString *)username password:(NSString *)password completion:(CompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGIN_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"username",username,@"password",password, nil];
    
    [[self AFHTTPManager] POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LOGIN RESPONSE:%@", responseObject);
        completion(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGIN ERROR:%@", error);
    }];
}

//logout 메소드
- (void)logoutRequest:(NSString *)token completion:(CompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGOUT_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"Authorizaion",token, nil];
    
    [[self AFHTTPManager] POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LOGOUT RESPONSE:%@", responseObject);
        completion(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGOUT ERROR:%@", error);
    }];
}

//postlist요청하는 메소드
- (void)postListRequest:(CompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, POST_URL];
    
    NSInteger pageNumber = 1;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"page",[NSString stringWithFormat:@"%@%@?page=%ld",BASIC_URL,POST_URL,pageNumber], nil];
    
    [[self AFHTTPManager] GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POSTLIST DATA:%@", responseObject);
        completion(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POSTLIST ERROR:%@", error);
    }];
}

//프로파일 이미지 요청 메소드
//- (void)profileImageRequest:(NSString)
@end
