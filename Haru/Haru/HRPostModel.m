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
        self.image                     = [dictionary objectForKey:IMAGE_KEY];
        self.userState                 = [[dictionary objectForKey:USERSTATE_KEY] integerValue];
        
        //totalDate format set
        self.dateFormatYear            = [self convertStringToDate:self.totalDate formattedData:HRDateFormatYear];
        self.dateFormatMonth           = [self convertStringToDate:self.totalDate formattedData:HRDateFormatMonth];
        self.dateFormatDay             = [self convertStringToDate:self.totalDate formattedData:HRDateFormatDay];
        self.dateFormatDayOfTheWeek    = [self convertStringToDate:self.totalDate formattedData:HRDateFormatDayOfTheWeek];
        self.dateFormatTime            = [self convertStringToDate:self.totalDate formattedData:HRDateFormatTime];
    }
    
    return self;
}

- (NSString *)convertStringToDate:(NSDate *)haruDate formattedData:(HRDateFormat)formattedData {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSString *formatChangedString = @"";
    
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    switch (formattedData) {
        
        case HRDateFormatYear:
            formatChangedString = @"yyyy";
        
        case HRDateFormatMonth:
            formatChangedString = @"MM";
            
        case HRDateFormatYearMonth:
            formatChangedString = @"yyyy년 MM월";
            
        case HRDateFormatDay:
            formatChangedString = @"dd";
            
        case HRDateFormatTime:
            formatChangedString = @"HH:mm:ss";
        
        case HRDateFormatDayOfTheWeek:
            formatChangedString = @"E";
    
        default:
            break;
    }
    
    [formatter setDateFormat:formatChangedString];
    
    return [formatter stringFromDate:haruDate];
    
}

@end
