//
//  HRCustomTableViewCell.h
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView      *customCellContent;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel     *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *dayOfTheWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel     *postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *userStateImageView;
@property (weak, nonatomic) IBOutlet UIView      *mainTableViewCellSectionView;
@property (weak, nonatomic) IBOutlet UILabel     *yearMonthLabel;


@end
