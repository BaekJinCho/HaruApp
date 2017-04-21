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


//login 메소드
- (void)loginRequest:(NSString *)username password:(NSString *)password completion:(CompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGIN_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"username",username,@"password",password, nil];
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LOGIN RESPONSE:%@", responseObject);
        completion(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGIN ERROR:%@", error);
    }];
}

//logout 메소드
//- (void)logoutRequest:(NSString *)token completion:(CompletionBlock)completion
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGOUT_URL];
//    NSLog(@"%@",url);
//    NSString *key = @"Authorization";
//    NSString *value = [NSString stringWithFormat:@"%@ %@",@"Token",token];
//    
//    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
//    
//    NSDictionary *parameter = [NSDictionary dictionaryWithObject:value forKey:key];
//    NSLog(@"%@", parameter);
//    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"LOGOUT RESPONSE:%@", responseObject);
//        completion(YES, responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"LOGOUT ERROR:%@%@", task, error);
//        completion(NO, nil);
//    }];
//}

- (void)logoutRequest:(NSString *)token completion:(ResponseBlock)completion
{
    NSString *value = [NSString stringWithFormat:@"%@ %@",@"Token",token];
    NSDictionary *headers = @{ @"authorization": value,
                               @"cache-control": @"no-cache"
                               };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://haru-eb.ap-northeast-2.elasticbeanstalk.com/logout/"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        completion(NO,nil);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        completion(YES,httpResponse);
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

///*NSURLSessionConfiguration 설정*/
//NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
///*AFHTTPSessionManager 설정*/
//self.afhttpSessionManager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
//
//self.afhttpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGOUT_URL];
//
//[self.afhttpSessionManager.requestSerializer setValue:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken] forHTTPHeaderField:TOKEN_KEY];
//
//[self.afhttpSessionManager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    
//    completion(YES,responseObject);
//    NSLog(@"LOGOUT RESPONSE:%@", responseObject);
//} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    NSLog(@"LOGOUT ERROR:%@", error);
//}];

- (void)getUserProfile:(CompletionBlock)completion 
{
//{
//    
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
//                               @"authorization": @"Token 1211486370dd43350fe4fa9eb6da93bdadcba35a",
//                               @"cache-control": @"no-cache",
//                               @"postman-token": @"f249d835-928a-2d2b-8c32-2af4e58a6eaf" };
//    NSArray *parameters = @[  ];
//    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
//    
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"fileName"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://haru.ycsinabro.com/user/"]
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:10.0];
//    [request setHTTPMethod:@"GET"];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if (error) {
//                                                        NSLog(@"%@", error);
//                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSLog(@"%@", httpResponse);
//                                                    }
//                                                }];
//    [dataTask resume];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL2, USER_URL];
    
//    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken] forHTTPHeaderField:TOKEN_KEY];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken],TOKEN_KEY, nil];
    
    [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
