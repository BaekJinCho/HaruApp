//
//  HRUserAFNetworkingModule.h
//  Haru
//
//  Created by SSangGA on 2017. 4. 7..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(BOOL Sucess, NSHTTPURLResponse *ResponseData);
typedef void (^CompletionBlock)(BOOL Sucess, NSDictionary *ResponseData);


@interface HRUserAFNetworkingModule : NSObject

- (void)postListRequest:(NSString *)token completion
                       :(CompletionBlock)completion;
- (void)getUserProfile:(CompletionBlock)completion;

@end
