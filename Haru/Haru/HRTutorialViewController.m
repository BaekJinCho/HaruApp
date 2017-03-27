//
//  ViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 25..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRTutorialViewController.h"
#import "HRSignupViewController.h"
//#import "HRLoginViewController.h"

@interface HRTutorialViewController ()
<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIView *tutorialContentView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage1;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage2;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage3;

@end

@implementation HRTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    for (NSInteger i=0; i<=3; i++) {
        if (i==0)  {
            self.tutorialImage1.backgroundColor = [UIColor redColor];
        } else if (i==1)  {
            self.tutorialImage2.backgroundColor = [UIColor greenColor];
        } else {
            self.tutorialImage3.backgroundColor = [UIColor yellowColor];
        }
        
    }
    
    [self.tutorialPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)changePage:(UIPageControl *)sender {
    [self.tutorialScrollView setContentOffset:CGPointMake([sender currentPage] * self.view.frame.size.width, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)tutorialSrollView {
    CGFloat position = [tutorialSrollView contentOffset].x / self.view.frame.size.width;
    self.tutorialPageControl.currentPage = position;
    
}

- (IBAction)clickSignupButton:(UIButton *)sender {
    UIStoryboard *signupStoryboard = [UIStoryboard storyboardWithName:@"HRSignup" bundle:nil];
    HRSignupViewController *signupView = [signupStoryboard instantiateViewControllerWithIdentifier:@"HRSignupViewController"];
    [self.navigationController pushViewController:signupView animated:YES];
    
}

- (IBAction)clickLoginButton:(UIButton *)sender {
    /*
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"HRLogin" bundle:nil];
    HRLoginViewController *loginView = [loginStoryboard instantiateViewControllerWithIdentifier:@"HRLoginViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
