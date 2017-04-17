//
//  HRDataCenter.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HRPostModel.h"

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

- (void)logoutRequestToServer:(BlockOnCompletion)completion;


- (void)mainViewList:(BlockOnCompletion)completion;


- (HRPostModel *)contentDataAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfItem;

- (void)readDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler;

- (void)writeDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler;


- (void)updateDiaryContent:(NSIndexPath *)haruContentsAtIndexPath haruContentsData:(HRPostModel *)haruContentsData;

@end
