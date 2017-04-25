//
//  HRCustomTableViewCell.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRCustomTableViewCell.h"


@implementation HRCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //mainTableViewCellSectionView 투명 만들어주기!
    self.mainTableViewCellSectionView.opaque          = NO;
    self.mainTableViewCellSectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
