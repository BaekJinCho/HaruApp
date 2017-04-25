//
//  HRPostModel.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRPostModel.h"



@implementation HRPostModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        self.totalDate                 = [dictionary objectForKey:DATE_KEY];
        self.title                     = [dictionary objectForKey:TITLE_KEY];
        self.content                   = [dictionary objectForKey:CONTENT_KEY];
        self.photo                     = [dictionary objectForKey:PHOTO_KEY];
        self.userState                 = [[dictionary objectForKey:USERSTATE_KEY] integerValue];
        self.userStateImage            = [self convertStringToUserState];
        
        //totalDate format set
//        self.dateFormatYear            = [self convertStringToDate:self.totalDate formattedData:HRDateFormatYear];
//        self.dateFormatMonth           = [self convertStringToDate:self.totalDate formattedData:HRDateFormatMonth];
//        self.dateFormatDay             = [self convertStringToDate:self.totalDate formattedData:HRDateFormatDay];
//        self.dateFormatDayOfTheWeek    = [self convertStringToDate:self.totalDate formattedData:HRDateFormatDayOfTheWeek];
//        self.dateFormatTime            = [self convertStringToDate:self.totalDate formattedData:HRDateFormatTime];
    }
    
    return self;
}

//user의 감정상태를 받기위한 Method
- (NSString *)convertStringToUserState {
    
    
    self.userStateImage = @" ";
    
    switch (self.userState) {
        
        case 0:
            self.userStateImage = @"Angry";
        case 1:
            self.userStateImage = @"Happy";
        case 2:
            self.userStateImage = @"Sad";
        case 3:
            self.userStateImage = @"Soso";
        case 4:
            self.userStateImage = @"Upset";
            
        default:
            break;
    }
    return self.userStateImage;
}

- (NSString *)convertWithDate:(NSDate *)date format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

- (UIImage *)retrieveUserState:(NSInteger)userState {
    
    UIImage *userStateImage;
    
    switch (userState) {
        case 0:
            userStateImage = [UIImage imageNamed:@"Happy"];
            return userStateImage;
            break;
        case 1:
            userStateImage = [UIImage imageNamed:@"Sad"];
            return userStateImage;
        case 2:
            userStateImage = [UIImage imageNamed:@"Angry"];
            return userStateImage;
        case 3:
            userStateImage = [UIImage imageNamed:@"Upset"];
            return userStateImage;
        case 4:
            userStateImage = [UIImage imageNamed:@"Soso"];
            return userStateImage;
            
        default:
            return nil;
            break;
    }
}

@end
