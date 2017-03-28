//
//  HRDataCenter.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRNetworkModule.h"

@interface HRDataCenter : NSObject

@property NSString *userToken;

+ (instancetype) sharedInstance;

- (NSString *)getUserToken;

@end
