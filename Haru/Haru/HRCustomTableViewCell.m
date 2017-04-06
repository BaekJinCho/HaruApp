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
    self.mainTableViewCellSectionView.opaque = NO;
    self.mainTableViewCellSectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    //mainTableViewCell 위에 년/월 표시해주는 label 설정
    self.mainTableViewCellYearMonthLabel.text = [NSString stringWithFormat:@"2017년 4월"];
    [self.mainTableViewCellYearMonthLabel setFont:[UIFont fontWithName:@"Apple SD Gothic Neo" size:17]];
    self.mainTableViewCellYearMonthLabel.textColor = [UIColor colorWithWhite:255/255.0 alpha:0.8];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
