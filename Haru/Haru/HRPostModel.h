//
//  HRPostModel.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const TITLE_KEY = @"Title";
static NSString * const CONTENT_KEY = @"content";
static NSString * const IMAGE_KEY = @"imageURL";
static NSString * const USERSATE_KEY = @"userState";

typedef NS_ENUM(NSUInteger, HRUserEmotionalState)
{
    HRUserEmotionalStateAngry,
    HRUserEmotionalStateHappy,
    HRUserEmotionalStateSad,
    HRUserEmotionalStateSoso,
    HRUserEmotionalStateUpset
};

@interface HRPostModel : NSObject

@property NSString *title;
@property NSString *content;
@property NSString *imageURL;
@property HRUserEmotionalState userState;


@end
