//
//  HRUserAFNetworkingModule.h
//  Haru
//
//  Created by SSangGA on 2017. 4. 7..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(BOOL Sucess, NSDictionary *ResponseData);

@interface HRUserAFNetworkingModule : NSObject

- (void)loginRequest:(NSString *)username password:(NSString *)password completion:(CompletionBlock)completion;

- (void)logoutRequest:(CompletionBlock)completion;

@end