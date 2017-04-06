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
        
        self.date = [dictionary objectForKey:DATE_KEY];
        self.title = [dictionary objectForKey:TITLE_KEY];
        self.content = [dictionary objectForKey:CONTENT_KEY];
        self.image = [dictionary objectForKey:IMAGE_KEY];
        self.userState = [[dictionary objectForKey:USERSTATE_KEY] integerValue];
        
    }
    return self;
}

@end
