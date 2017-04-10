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


@interface HRUserAFNetworkingModule ()


@end

@implementation HRUserAFNetworkingModule

- (void)loginRequest:(NSString *)username password:(NSString *)password completion:(CompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGIN_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"username",username,@"password",password, nil];
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        completion(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)logoutRequest:(CompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGOUT_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"Authorizaion",@"tokenvalue", nil];
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        completion(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

//- (void)profileImageRequest:(NSString)
@end
