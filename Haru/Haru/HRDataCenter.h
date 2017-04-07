//
//  HRDataCenter.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRDataCenter : NSObject

@property NSString *userToken;

+ (instancetype)sharedInstance;

- (NSString *)getUserToken;

- (BOOL)isAutoLogin;

//회원가입 & 로그인 메소드
- (void)joinRequestWithUserID:(NSString *)userID
                       password:(NSString *)password
                      password2:(NSString *)password2
                     completion:(BlockOnCompletion)completion;

- (void)loginRequestWithUserID:(NSString *)userID
                      password:(NSString *)password
                    completion:(BlockOnCompletion)completion;
@end
