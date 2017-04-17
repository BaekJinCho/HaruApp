//
//  HRCollectionViewCell.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRCollectionViewCell.h"

@interface HRCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *cellMainView;


@end

@implementation HRCollectionViewCell

//- (void) inputDataIntoCell:(HRRealmData *)data {
//    
//    UIImage *mainImage = [UIImage imageWithData:data.mainImageData];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
//    [formatter setDateFormat:@"yyyy년 M월 dd일"];
//    [formatter setLocale:locale];
//    NSString *savedDate = [formatter stringFromDate:data.date];
//    
//    self.imageView.image = mainImage;
//    self.dateTextView.text = savedDate;
//    self.titleTextView.text = data.title;
//}

@end
