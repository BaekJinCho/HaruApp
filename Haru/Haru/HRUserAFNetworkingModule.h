//
//  HRUserAFNetworkingModule.h
//  Haru
//
//  Created by SSangGA on 2017. 4. 7..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(BOOL Sucess, NSHTTPURLResponse *ResponseData);
typedef void (^CompletionBlock)(BOOL Sucess, id ResponseData);

@interface HRUserAFNetworkingModule : NSObject

- (void)loginRequest:(NSString *)username password:(NSString *)password completion:(CompletionBlock)completion;

- (void)logoutRequest:(NSString *)token completion:(ResponseBlock)completion;

- (void)postListRequest:(NSString *)token completion
                       :(CompletionBlock)completion;
- (void)getUserProfile;

@end
