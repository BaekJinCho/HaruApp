//
//  HRNetworkModule.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRNetworkModule.h"
#import "HRDataCenter.h"

static NSString * const TOKEN_KEY = @"Authorization";

static NSInteger const STATUSCODE_LOGIN_SUCCESS = 200;
static NSInteger const STATUSCODE_SIGNUP_SUCCESS = 201;
static NSInteger const STATUSCODE_LOGOUT_SUCCESS = 200;


@implementation HRNetworkModule

#pragma mark - Account Request

// 로그인 요청
-(void)loginRequestToServer:(NSString *)userID
                   password:(NSString *)password
                 completion:(BlockOnCompletion)completion {
    
    // session 생성
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // request 생성
    NSMutableURLRequest *request = [self mutableURLRequest:LOGIN_URL];
    request.HTTPMethod = POST_METHOD;
    
    // request data 생성 및 인코딩
    NSString *requestData = [self makeLoginBody:userID password:password];
    request.HTTPBody = [requestData dataUsingEncoding:NSUTF8StringEncoding];
    
    // task 생성하여 session 업로드
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
                                                         fromData:nil
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&error];
        if (httpResponse.statusCode == STATUSCODE_LOGIN_SUCCESS) {
            completion(YES, responseData);
        } else {
            completion(NO, responseData);
        }
    }];
    
    [task resume];
}

// 회원가입 요청
-(void)signupRequestToServer:(NSString *)userID
                    password:(NSString *)password
                   password2:(NSString *)password2
                  completion:(BlockOnCompletion)completion {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [self mutableURLRequest:SIGNUP_URL];
    request.HTTPMethod = POST_METHOD;
    
    NSString *requestData = [self makeSignupBody:userID password:password password2:password2];
    request.HTTPBody = [requestData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
                                                         fromData:nil
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:NSJSONReadingMutableLeaves
                                                                                                                   error:&error];
                                                    if (httpResponse.statusCode == STATUSCODE_SIGNUP_SUCCESS) {
                                                        completion (YES, responseData);
                                                    } else {
                                                        completion (NO, responseData);
                                                    }
                                                }];
    [task resume];
}


-(void)logoutRequestToServer:(BlockOnCompletion)completion {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [self mutableURLRequest:LOGOUT_URL];
    request.HTTPMethod = POST_METHOD;
    
    [request setValue:[self tokenValue] forHTTPHeaderField:TOKEN_KEY];
    
    NSURLSessionUploadTask *logoutTask = [session uploadTaskWithRequest:request
                                                               fromData:nil
                                                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&error];
          if (httpResponse.statusCode == STATUSCODE_LOGOUT_SUCCESS) {
              completion (YES, responseData);
          } else {
              completion (NO, responseData);
          }
      }];
    [logoutTask resume];
}


#pragma mark - Private Method

// URL 관련 메소드화
- (NSMutableURLRequest *)mutableURLRequest:(NSString *)urlStr {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASIC_URL, urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    return request;
}


- (NSString *) tokenValue {
    
    return [NSString stringWithFormat:@"Token %@", [[HRDataCenter sharedInstance] getUserToken]];
}


// 로그인 form data 메소드화
- (NSString *)makeLoginBody:(NSString *)userName
                   password:(NSString *)password {
    
    return [NSString stringWithFormat:@"username=%@&password=%@", userName, password];
}


// 회원가입 form data 메소드화
- (NSString *)makeSignupBody:(NSString *)userName
                    password:(NSString *)password
                   password2:(NSString *)password2 {
    
    return [NSString stringWithFormat:@"username=%@&password1=%@&password2=%@", userName, password, password2];
}

@end
