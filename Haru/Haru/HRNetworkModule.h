//
//  HRNetworkModule.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BlockOnCompletion)(BOOL isSuccess, id response);

// URL 전역변수로 선언
// 테스트 API로 구현되어 있음.
static NSString * const BASIC_URL = @"https://fc-ios.lhy.kr/api";
static NSString * const SIGNUP_URL = @"/member/signup/";
static NSString * const LOGIN_URL = @"/member/login/";
static NSString * const LOGOUT_URL = @"/member/logout/";

static NSString * const POST_METHOD = @"POST";
static NSString * const GET_METHOD = @"GET";


@interface HRNetworkModule : NSObject


-(void)loginRequestToServer:(NSString *)userID
                   password:(NSString *)password
                 completion:(BlockOnCompletion)completion;

-(void)signupRequestToServer:(NSString *)userID
                    password:(NSString *)password
                   password2:(NSString *)password2
                  completion:(BlockOnCompletion)completion;

-(void)logoutRequestToServer:(BlockOnCompletion)completion;


@end
