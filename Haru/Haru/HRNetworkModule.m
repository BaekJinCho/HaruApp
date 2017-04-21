//
//  HRNetworkModule.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRNetworkModule.h"


@implementation HRNetworkModule

#pragma mark - Account Request

// 로그인 요청(AFNetwork)
- (void)loginRequestToServer:(NSString *)userID
                   password:(NSString *)password
                 completion:(BlockOnCompletion)completion {
/***********************************************기본 Network 로직*********************************************/
//    // session 생성
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    // request 생성
//    NSMutableURLRequest *request = [self mutableURLRequest:LOGIN_URL];
//    request.HTTPMethod = POST_METHOD;
//    
//    // request data 생성 및 인코딩
//    NSString *requestData = [self makeLoginBody:userID password:password];
//    request.HTTPBody = [requestData dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // task 생성하여 session 업로드
//    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
//                                                         fromData:nil
//                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
//                                                                     options:NSJSONReadingMutableLeaves
//                                                                       error:&error];
//                                                    if (httpResponse.statusCode == STATUSCODE_LOGIN_SUCCESS) {
//                                                        completion(YES, responseData);
//                                                    } else if (httpResponse.statusCode == STATUSCODE_LOGIN_FAIL){
//                                                        completion(NO, responseData);
//                                                    }
//                                                }];
//    [task resume];
/***********************************************기본 Network 로직*********************************************/

    /*NSURLSessionConfiguration 설정*/
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /*AFHTTPSessionManager 설정*/
    self.afhttpSessionManager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
    
    
    /*url 설정*/
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGIN_URL];
    
    /*parameters 설정*/
    NSDictionary *parameters = @{@"email":userID, @"password":password};
    
    
    /* */
    [self.afhttpSessionManager POST:url parameters:parameters progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        completion(YES,responseObject);
        
        NSLog(@"LOGIN RESPONSE:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGIN ERROR:%@", error);
        
        completion(NO,(NSHTTPURLResponse *)task.response);
    }];
    
    

/*******************************AFNetwork*******************************/
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGIN_URL];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"email",userID,@"password",password, nil];
//
//    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//       
//        completion(YES,responseObject);
//        NSLog(@"LOGIN RESPONSE:%@", responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"LOGIN ERROR:%@", error);
//    }];
    
    
}

// 회원가입 요청(AFNetwork)
- (void)joinRequestToServer:(NSString *)userID
                    password:(NSString *)password
                   password2:(NSString *)password2
                  completion:(BlockOnCompletion)completion {

/***********************************************기본 Network 로직*********************************************/
    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSMutableURLRequest *request = [self mutableURLRequest:JOIN_URL];
//    request.HTTPMethod = POST_METHOD;
//    
//    NSString *requestData = [self makeSignupBody:userID password:password password2:password2];
//    request.HTTPBody = [requestData dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
//                                                         fromData:nil
//                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                                                    
//                                                    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                                                    
//                                                    if (httpResponse.statusCode == STATUSCODE_JOIN_SUCCESS) {
//                                                        completion (YES, responseData);
//                                                    } else if(httpResponse.statusCode == STATUSCODE_SIGNUP_FAIL){
//                                                        completion(NO, responseData);
//                                                    } else if(httpResponse.statusCode == STATUSCODE_SIGNUP_FAIL2){
//                                                        completion(NO, responseData);
//                                                    }
//                                                    
//
//                                                }];
//    [task resume];
    
/***********************************************기본 Network 로직*********************************************/
    
    /*NSURLSessionConfiguration 설정*/
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /*AFHTTPSessionManager 설정*/
    self.afhttpSessionManager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
    
    /*url 설정*/
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, JOIN_URL];
    
    /*parameters 설정*/
    NSDictionary *parameters = @{@"email":userID, @"password":password};

    
    /* */
    [self.afhttpSessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(YES,responseObject);
        NSLog(@"LOGIN RESPONSE:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGIN ERROR:%@", error);
        completion(NO,(NSHTTPURLResponse *)task.response);
    }];
    
    
}

//로그아웃 요청
- (void)logoutRequestToServer:(BlockOnCompletion)completion {
    
    /*NSURLSessionConfiguration 설정*/
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /*AFHTTPSessionManager 설정*/
    self.afhttpSessionManager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
    
    self.afhttpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", BASIC_URL, LOGOUT_URL];
    
    [self.afhttpSessionManager.requestSerializer setValue:[@"Token " stringByAppendingString:[HRDataCenter sharedInstance].userToken] forHTTPHeaderField:TOKEN_KEY];
    
    [self.afhttpSessionManager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(YES,responseObject);
        NSLog(@"LOGOUT RESPONSE:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LOGOUT ERROR:%@", error);
    }];
    
    
}

#pragma mark- Private Method

//URL 관련 메소드화
- (NSMutableURLRequest *)mutableURLRequest:(NSString *)urlStr {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASIC_URL, urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    return request;
}

//token 값 메소드화
- (NSString *)tokenValue {
    
    return [NSString stringWithFormat:@"Token %@", [[HRDataCenter sharedInstance] getUserToken]];
}

//로그인 form data 메소드화
- (NSString *)makeLoginBody:(NSString *)email
                   password:(NSString *)password {
    
    return [NSString stringWithFormat:@"email=%@&password=%@", email, password];
}

//회원가입 form data 메소드화
- (NSString *)makeSignupBody:(NSString *)email
                    password:(NSString *)password
                   password2:(NSString *)password2 {
    
    return [NSString stringWithFormat:@"email=%@&password=%@&password2=%@", email, password, password2];
}


//Post form 메소드화
- (void)postRequestTilte:(NSString *)title
                 content:(NSString *)content
                   image:(NSData *)image
                    date:(NSDate *)date
               userState:(NSUInteger)userState
              completion:(BlockOnCompletion)completion {
    
    
    
    
}

//Server에서 page 단위로 받는것 메소드화
- (void)postListRequestWithPage:(NSNumber *)requestPage
                     completion:(BlockOnCompletion)completion {


}

// HR main list
- (void)testList:(BlockOnCompletion)completion {
    
    [self readDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
        
        completion(isSuccess, response);
    }];
}

//json 파일 읽는 Method
- (void)readDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"inHaru" ofType:@"json"];
    
    NSData *partyData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //convert JSON NSData to a usable NSDictionary
    NSError *error;
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:partyData
                                                                 options:0
                                                                   error:&error];
    
    completionHandler(YES, responseData);
}




@end
