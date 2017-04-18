//
//  HRLoginViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 28..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRLoginViewController.h"

@interface HRLoginViewController ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *loginContentView;
@property (weak, nonatomic) IBOutlet UITextField *loginIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *LoginPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@end

@implementation HRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //loginPasswordTextField *로 표시
    self.LoginPasswordTextField.secureTextEntry = YES;
    
    // 텍스트 필드 placeholder 컬러
    UIColor *color = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.7];
    self.loginIDTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"haru@haru.com" attributes:@{NSForegroundColorAttributeName:color}];
    self.LoginPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"비밀번호" attributes:@{NSForegroundColorAttributeName:color}];
    
    
    //UIView 투명 만들어주기!
    self.loginContentView.opaque = NO;
    self.loginContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    //notification으로 loginScrollView 올리기!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChanedLoginScrollView:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChanedLoginScrollView:) name:UIKeyboardWillShowNotification object:nil];
    
    
    
    
}

//notification으로 loginScrollView 올리는 Method
#pragma mark- loginView notification Method
- (void)didChanedLoginScrollView:(NSNotification *) notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [self.loginScrollView setContentOffset:CGPointMake(0, keyboardRect.size.height-145) animated:YES];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    NSLog(@"%lf", keyboardRect.size.width);
    
}

//notification dealloc
#pragma mark- signupView notification dealloc Method
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//loginstoryboard 텍스트 필드에서 return 클릭했을 때, 불리는 delegate method
#pragma mark- loginView TextField delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.LoginPasswordTextField becomeFirstResponder];
    } else {
        [self.LoginPasswordTextField resignFirstResponder];
        [self clickLoginButton:self.loginButton];
    }
    return YES;
}

//로그인 버튼을 눌렀을 때, 불리는 Method
#pragma mark- loginView loginButtonClick Method
- (IBAction)clickLoginButton:(UIButton *)sender {
    
    NSString *loginIDText = self.loginIDTextField.text;
    NSString *loginPasswordText = self.LoginPasswordTextField.text;
    [self.loginIndicator startAnimating];

    [[HRDataCenter sharedInstance] loginRequestWithUserID:loginIDText password:loginPasswordText completion:^(BOOL isSuccess, id response) {
        
        if (isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"로그인 성공 / token:::%@",response);
            
            [self loginSucessAlert];
            });
            
            
        } else {
            
            if ([[response objectForKey:@"email"] objectAtIndex:0] || [[response objectForKey:@"password"] objectAtIndex:0]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"로그인 실패 / token:::%@",response);
                    NSString *loginFailMessage = @"이메일 또는 비밀번호를 입력해주세요";
                    [self loginFailAlert:loginFailMessage];
                });

            }
        }
        
        [self.loginIndicator stopAnimating];
        
    }];
    
    
}

//로그인 성공 alert
- (void)loginSucessAlert {
    
    UIAlertController *sucessAlert = [UIAlertController alertControllerWithTitle:@"성공" message:@"로그인이 정상적으로 완료되었습니다." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [sucessAlert addAction:ok];
    [self presentViewController:sucessAlert animated:YES completion:nil];
}

//로그인 실패 alert
- (void)loginFailAlert:(NSString *)failMessage {
    
    UIAlertController *sucessAlert = [UIAlertController alertControllerWithTitle:@"실패" message:failMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [sucessAlert addAction:ok];
    [self presentViewController:sucessAlert animated:YES completion:nil];
}

//로그인 페이지 뷰의 어느곳을 클릭해도 키보드 내리는 Method
#pragma mark- loginVeiwTabGesture Method
- (IBAction)loginViewTabGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
