//
//  HRDetailViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRDetailViewController.h"
#import "HRCustomTableViewCell.h"
#import "HRMainViewController.h"
#import "HRUpdateViewController.h"

@interface HRDetailViewController ()

@end

@implementation HRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%ld", self.indexPath.row);
    
    if(self.postModel == nil) {
        
        NSLog(@"Error : Empty Data");
    } else {
        
        NSLog(@"%@", self.postModel);
        
        self.detailViewPostTitle.text           = self.postModel.title;
        self.detailViewContentLabel.text        = self.postModel.content;
        self.detailViewUserStateImageView.image = [UIImage imageNamed:self.postModel.userStateImage];
        self.detailViewDayLabel.text            = [self.postModel convertWithDate:self.postModel.totalDate format:@"dd"];
        self.detailViewDayOfWeekLabel.text      = [self.postModel convertWithDate:self.postModel.totalDate format:@"E"];
        [self.detailViewBackgroundPhoto sd_setImageWithURL:[NSURL URLWithString:self.postModel.photo]
                                          placeholderImage:[UIImage imageNamed:@""]];
        
    }
    
}

//연필 버튼을 클릭했을 떄, 불리는 Method
- (IBAction)clickUpdateButton:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"updateViewFromDetailView" sender:sender];
    
}
//detail 페이지에 있는 data를 update 페이지에도 같은 데이터가 적용되도록 하기위한 Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"updateViewFromDetailView"]) {
    
        HRUpdateViewController *updateView = [segue destinationViewController];
        updateView.postModel = self.postModel;
    
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
