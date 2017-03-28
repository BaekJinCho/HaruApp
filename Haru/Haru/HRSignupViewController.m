//
//  HRSignupViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRSignupViewController.h"
#import "HRDataCenter.h"

@interface HRSignupViewController ()
<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *signupContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *signupScrollView;
@property (weak, nonatomic) IBOutlet UITextField *signupIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordCheckTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *signupIndicator;

@end

@implementation HRSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //signupPasswordTextField *로 표시
    self.signupPasswordTextField.secureTextEntry = YES;
    self.signupPasswordCheckTextField.secureTextEntry = YES;
    
    //UIView 투명 만들어주기!
    self.signupContentView.opaque = NO;
    self.signupContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    //notification으로 signupScrollView 올리기!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChaneSignupScrollView:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChaneSignupScrollView:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//notification으로 signupScrollView 올리는 Method
#pragma mark- signupView notification Method
- (void)didChaneSignupScrollView:(NSNotification *) notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [self.signupScrollView setContentOffset:CGPointMake(0, keyboardRect.size.height-170) animated:YES];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        [self.signupScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    NSLog(@"%lf", keyboardRect.size.width);

}
//notification dealloc
#pragma mark- signupView notification dealloc Method
- (void)dealloc {
}
//signup storyboard 텍스트 필드에서 return 클릭했을 때, 불리는 delegate method
#pragma mark- signupView TextField ShouldReturn Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self.signupPasswordTextField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.signupPasswordCheckTextField becomeFirstResponder];
    } else
        [self.signupPasswordCheckTextField resignFirstResponder];
    return YES;
}
//회원가입 버튼을 눌렀을 때, 불리는 Method
#pragma mark- signupView signupButtonClick Method
- (IBAction)clickSignupButton:(UIButton *)sender {
    [self.signupIndicator startAnimating];
    NSString *signUpIDText = self.signupIDTextField.text;
    NSString *signUpPasswordText = self.signupPasswordTextField.text;
    NSString *signUpPasswordCheckText = self.signupPasswordCheckTextField.text;
    
    [[HRDataCenter sharedInstance]signupRequestWithUserID:signUpIDText password:signUpPasswordText password2:signUpPasswordCheckText completion:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            NSLog(@"로그인 성공 / token:::%@",response);
        } else {
            NSLog(@"로그인 실패! token 따위는 없다.");
        }
    }];
    
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
