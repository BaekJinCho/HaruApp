//
//  ViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 25..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRTutorialViewController.h"
#import "HRJoinViewController.h"
#import "HRLoginViewController.h"

@interface HRTutorialViewController ()
<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIView *tutorialContentView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage1;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage2;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage3;
@property (weak, nonatomic) IBOutlet UIButton *tutorialLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialJoinButton;

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
    
    //네이게이션 바 아래 bottom hight 1 없애기
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    [self.tutorialPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
}
//view가 화면에 보이지기 직전에 navigation 숨기기
#pragma mark- tutorialViewController viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
//view가 화면에 사라지기 직전에 navigation 나타내기
#pragma mark- tutorialViewController viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
//UIPageControl Method
#pragma mark- tutorialViewController pageControl Method
- (IBAction)changePage:(UIPageControl *)sender {
    [self.tutorialScrollView setContentOffset:CGPointMake([sender currentPage] * self.view.frame.size.width, 0) animated:YES];
}

//스크롤할 때마다 현재 페이지와 맞게 PageControl Set
#pragma mark- tutorialViewController scrollView Method
- (void)scrollViewDidScroll:(UIScrollView *)tutorialSrollView {
    CGFloat position = [tutorialSrollView contentOffset].x / self.view.frame.size.width;
    self.tutorialPageControl.currentPage = position;
    
}
//회원가입 버튼 클릭했을 때, 행동하는 Method
#pragma mark- tutorialViewController Signup Button Method
- (IBAction)clickSignupButton:(UIButton *)sender {
    
//    UIStoryboard *signupStoryboard = [UIStoryboard storyboardWithName:@"HRJoin" bundle:nil];
//    HRJoinViewController *signupView = [signupStoryboard instantiateViewControllerWithIdentifier:@"HRJoinViewController"];
//    [self.navigationController pushViewController:signupView animated:YES];
    
}
//로그인 버튼 클릭했을 때, 행동하는 Method
#pragma mark- tutorialViewController Login Button Method
- (IBAction)clickLoginButton:(UIButton *)sender {
    
    /*
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"HRLogin" bundle:nil];
    HRLoginViewController *loginView = [loginStoryboard instantiateViewControllerWithIdentifier:@"HRLoginViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
     */
    
//    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindTutorialSegue:(UIStoryboardSegue *)sender {
    
}


@end
