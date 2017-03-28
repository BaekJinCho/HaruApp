//
//  HRDataCenter.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRDataCenter.h"
#import "HRNetworkModule.h"

// 서버에서 받은 키값을 변수에 저장
static NSString *const ACCOUNT_KEY_OF_SERVER  = @"key";
// 서버에서 받은 키값을 
static NSString *const TOKEN_KEY_OF_USERDEFAULTS = @"token";

@interface HRDataCenter ()

@property (nonatomic) HRNetworkModule *networkManager;

@end

@implementation HRDataCenter


// 싱글턴
+ (instancetype) sharedInstance {
    
    static HRDataCenter *center;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[HRDataCenter alloc] init];
    });
    return center;
}


// 초기화 메소드
- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkManager = [[HRNetworkModule alloc] init];
        self.userToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    }
    return self;
}


- (NSString *)getUserToken
{
    if (_userToken == nil) {
        _userToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    }
    return _userToken;
}


- (void)loginRequestWithUserID:(NSString *)userID password:(NSString *)password completion:(BlockOnCompletion)completion {
    
    [self.networkManager loginRequestToServer:userID
                                     password:password
                                   completion:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            self.userToken = [response objectForKey:ACCOUNT_KEY_OF_SERVER];
            [[NSUserDefaults standardUserDefaults] setObject:self.userToken forKey:TOKEN_KEY_OF_USERDEFAULTS];
        }
    }];
}


- (void)signupRequestWithUserID:(NSString *)userID
                        password:(NSString *)password
                       password2:(NSString *)password2
                     completion:(BlockOnCompletion)completion {
    
    [self.networkManager signupRequestToServer:userID
                                      password:password
                                     password2:password2
                                    completion:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            self.userToken = [response objectForKey:ACCOUNT_KEY_OF_SERVER];
            [self saveToken:self.userToken];
        }
    }];
}


- (void)logoutRequestWithUserID {
    
    [self removeToken];
}


#pragma mark - Private Method

- (void) saveToken:(NSString *)token {
    
    self.userToken = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN_KEY_OF_USERDEFAULTS];
}


- (void)removeToken {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY_OF_USERDEFAULTS];
}




@end
