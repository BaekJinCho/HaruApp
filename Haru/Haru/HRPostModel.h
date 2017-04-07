//
//  HRPostModel.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

//유저 감정상태 정의
typedef NS_ENUM(NSUInteger, HRUserEmotionalState) {
    HRUserEmotionalStateAngry,
    HRUserEmotionalStateHappy,
    HRUserEmotionalStateSad,
    HRUserEmotionalStateSoso,
    HRUserEmotionalStateUpset
};

@interface HRPostModel : NSObject

@property NSDate *date;
@property NSDateComponents *dateComponents;
@property NSString *title;
@property NSString *content;
@property NSString *image;
@property HRUserEmotionalState userState;


@end
