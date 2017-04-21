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

typedef NS_ENUM(NSUInteger, HRDateFormat) {
    HRDateFormatYear,
    HRDateFormatMonth,
    HRDateFormatYearMonth,
    HRDateFormatDay,
    HRDateFormatDayOfTheWeek,
    HRDateFormatTime
};


@interface HRPostModel : NSObject

@property (nonatomic) HRUserEmotionalState userState;
@property (nonatomic) NSString        *userStateImage;

@property (nonatomic) NSDate          *totalDate;

@property (nonatomic) NSString        *title;
@property (nonatomic) NSString        *content;
@property (nonatomic) NSString        *photo;


//totalDate 각각의 View의 보여줄 format으로 변환에 필요한 프로퍼티
@property (nonatomic) NSString        *dateFormatYear;
@property (nonatomic) NSString        *dateFormatMonth;
@property (nonatomic) NSString        *dateFormatYearMonth;
@property (nonatomic) NSString        *dateFormatDay;
@property (nonatomic) NSString        *dateFormatDayOfTheWeek;
@property (nonatomic) NSString        *dateFormatTime;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)convertWithDate:(NSDate *)date format:(NSString *)format;
- (UIImage *)retrieveUserState:(NSInteger)userState;
@end
