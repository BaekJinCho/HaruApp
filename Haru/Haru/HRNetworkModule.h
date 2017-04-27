//
//  HRNetworkModule.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BlockOnCompletion)(BOOL isSuccess, id response);
typedef void (^ResponseBlock)(BOOL Sucess, NSHTTPURLResponse *ResponseData);
typedef void (^CompletionBlock)(BOOL Sucess, NSDictionary *ResponseData);

@interface HRNetworkModule : NSObject

@property (nonatomic) NSMutableArray * diaryDataArray;
@property (nonatomic) AFHTTPSessionManager *afhttpSessionManager;


//@interface HRUserAFNetworkingModule : NSObject

- (void)postListRequest:(NSString *)token completion
                       :(CompletionBlock)completion;
- (void)getUserProfile:(CompletionBlock)completion;

- (void)loginRequestToServer:(NSString *)userID
                   password:(NSString *)password
                 completion:(BlockOnCompletion)completion;

- (void)joinRequestToServer:(NSString *)userID
                    password:(NSString *)password
                   password2:(NSString *)password2
                  completion:(BlockOnCompletion)completion;

- (NSString *)tokenValue;

- (void)logoutRequestToServer:(BlockOnCompletion)completion;

- (void)readDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler;


@end
