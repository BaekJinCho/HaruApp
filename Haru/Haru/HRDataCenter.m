//
//  HRDataCenter.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRDataCenter.h"

@interface HRDataCenter ()

@property (nonatomic) HRNetworkModule *networkManager;

@end

@implementation HRDataCenter


//싱글턴
+ (instancetype) sharedInstance {
    
    static HRDataCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[HRDataCenter alloc] init];
    });
    return center;
}


//초기화 메소드
- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkManager = [[HRNetworkModule alloc] init];
    }
    return self;
}

//유저의 token 값 저장
- (NSString *)getUserToken
{
    if (self.userToken == nil) {
        self.userToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    }
    return self.userToken;
}

//자동 로그인 체크하는 Method
- (BOOL)isAutoLogin {
    
    NSString *loginNewToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    if (loginNewToken != nil) {
        self.userToken = loginNewToken;
        return YES;
    }
    return NO;
    
}

//로그인 Method
- (void)loginRequestWithUserID:(NSString *)userID
                      password:(NSString *)password
                    completion:(BlockOnCompletion)completion {
    
    [self.networkManager loginRequestToServer:userID
                                     password:password
                                   completion:^(BOOL isSuccess, id response) {
                                       if (isSuccess == YES) {
                                           NSString *token = [(NSDictionary *)response objectForKey:ACCOUNT_KEY_OF_SERVER];
                                           [self saveToken:token];
                                       }
                                       completion(isSuccess, response);
                                   }];
}

//회원가입 Method
- (void)joinRequestWithUserID:(NSString *)userID
                        password:(NSString *)password
                       password2:(NSString *)password2
                     completion:(BlockOnCompletion)completion {
    
    [self.networkManager joinRequestToServer:userID
                                      password:password
                                     password2:password2
                                    completion:^(BOOL isSuccess, id response) {
                                        
                                        if (isSuccess == YES) {
                    
                                            NSString *token = [(NSDictionary *)response objectForKey:ACCOUNT_KEY_OF_SERVER];
                                            [self saveToken:token];
                                        }
                                        completion(isSuccess, response);
    }];
}


- (void)logoutRequestWithUserID {
    
    [self removeToken];
}


#pragma mark - Private Method

- (void)saveToken:(NSString *)token {
    
    self.userToken = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN_KEY_OF_USERDEFAULTS];
}


- (void)removeToken {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY_OF_USERDEFAULTS];
}


//Post 관련 Method





@end
