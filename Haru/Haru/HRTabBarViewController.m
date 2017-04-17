//
//  HRTabBarViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 4. 7..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRTabBarViewController.h"

@interface HRTabBarViewController ()

@end

@implementation HRTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//viewDidAppear에서 자동 로그인 체크
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (![[HRDataCenter sharedInstance] isAutoLogin]) {
        [self showTutorialPage];
    }
  
}

//TutorialPage를 보여주는 Method
- (void)showTutorialPage {
    
    [self performSegueWithIdentifier:@"showTutorial" sender:self];
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
