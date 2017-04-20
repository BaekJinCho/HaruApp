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

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self.checkBox setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    } else {
        [self.checkBox setImage:[UIImage imageNamed:@"checkBoxSelected"] forState:UIControlStateNormal];
    }
}
@end
