//
//  HRSignupViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRJoinViewController.h"
#import "HRDataCenter.h"

@interface HRJoinViewController ()
<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *joinContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *joinScrollView;
@property (weak, nonatomic) IBOutlet UITextField *joinIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *joinPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *joinPasswordCheckTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *joinIndicator;

@end

@implementation HRJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //signupPasswordTextField *로 표시
    self.joinPasswordTextField.secureTextEntry = YES;
    self.joinPasswordCheckTextField.secureTextEntry = YES;
    
    // 텍스트 필드 placeholder 컬러
    UIColor *color = [UIColor lightGrayColor];
    self.joinIDTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"haru@haru.com" attributes:@{NSForegroundColorAttributeName:color}];
    self.joinPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"비밀번호" attributes:@{NSForegroundColorAttributeName:color}];
    self.joinPasswordCheckTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"비밀번호 확인" attributes:@{NSForegroundColorAttributeName:color}];
    
    //회원가입 버튼 background color
    self.joinButton.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.joinButton.layer.borderColor = [UIColor blueColor].CGColor;
    
    //UIView 투명 만들어주기!
    self.joinContentView.opaque = NO;
    self.joinContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
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
        
        [self.joinScrollView setContentOffset:CGPointMake(0, keyboardRect.size.height-195) animated:YES];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        [self.joinScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
        [self.joinPasswordTextField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.joinPasswordCheckTextField becomeFirstResponder];
    } else
        [self.joinPasswordCheckTextField resignFirstResponder];
    return YES;
}
//회원가입 버튼을 눌렀을 때, 불리는 Method
#pragma mark- signupView signupButtonClick Method
- (IBAction)clickSignupButton:(UIButton *)sender {
    [self.joinIndicator startAnimating];
    NSString *signUpIDText = self.joinIDTextField.text;
    NSString *signUpPasswordText = self.joinPasswordTextField.text;
    NSString *signUpPasswordCheckText = self.joinPasswordCheckTextField.text;
    
    [[HRDataCenter sharedInstance]signupRequestWithUserID:signUpIDText password:signUpPasswordText password2:signUpPasswordCheckText completion:^(BOOL isSuccess, id response) {
        if (isSuccess == YES) {
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
