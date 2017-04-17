//
//  HRRealmDataModel.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 4. 14..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <Realm/Realm.h>

@interface HRRealmData : RLMObject

@property NSString *title;
@property NSString *content;
@property NSData *mainImageData;
@property NSInteger emoticonValue;
@property NSDate *date;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<HRRealmData *><HRRealmData>
RLM_ARRAY_TYPE(HRRealmData)
