//
//  HRDetailViewController.h
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRDetailViewController : UIViewController

@property (nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *detailViewUserStateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailViewBackgroundPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailViewDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailViewDayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailViewPostTitle;
@property (weak, nonatomic) IBOutlet UIImageView *detailViewUserState;
@property (weak, nonatomic) IBOutlet UILabel *detailViewContentLabel;

@property (nonatomic) HRPostModel *postModel;

@end
