//
//  HRSignupViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRJoinViewController.h"
#import "HRDataCenter.h"
#import "HRRealmData.h"

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
    
    //SignupPasswordTextField *로 표시
    self.joinPasswordTextField.secureTextEntry      = YES;
    self.joinPasswordCheckTextField.secureTextEntry = YES;
    
    // 텍스트 필드 placeholder 컬러
    UIColor *color = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.7];
    self.joinIDTextField.attributedPlaceholder            = [[NSAttributedString alloc] initWithString:@"haru@haru.com" attributes:@{NSForegroundColorAttributeName:color}];
    self.joinPasswordTextField.attributedPlaceholder      = [[NSAttributedString alloc] initWithString:@"비밀번호(8자 이상)" attributes:@{NSForegroundColorAttributeName:color}];
    self.joinPasswordCheckTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"비밀번호 확인" attributes:@{NSForegroundColorAttributeName:color}];
    
    //UIView 투명 만들어주기!
    self.joinContentView.opaque          = NO;
    self.joinContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    //notification으로 signupScrollView 올리기!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChanedSignupScrollView:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChanedSignupScrollView:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Notification으로 SignupScrollView 올리는 Method
#pragma mark- JoinView notification Method
- (void)didChanedSignupScrollView:(NSNotification *) notification {
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [self.joinScrollView setContentOffset:CGPointMake(0, keyboardRect.size.height-120) animated:YES];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        [self.joinScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    NSLog(@"%lf", keyboardRect.size.width);

}

//Notification dealloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Signup storyboard 텍스트 필드에서 return 클릭했을 때, 불리는 delegate method
#pragma mark- JoinView TextField ShouldReturn Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self.joinPasswordTextField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.joinPasswordCheckTextField becomeFirstResponder];
    } else {
        [self.joinPasswordCheckTextField resignFirstResponder];
        [self clickSignupButton:self.joinButton];
    }
    return YES;
}

//회원가입 버튼을 눌렀을 때, 불리는 Method
#pragma mark- JoinView Signup Button Click Method
- (IBAction)clickSignupButton:(UIButton *)sender {
    
    [self.joinIndicator startAnimating];
    NSString *signUpIDText = self.joinIDTextField.text;
    NSString *signUpPasswordText = self.joinPasswordTextField.text;
    NSString *signUpPasswordCheckText = self.joinPasswordCheckTextField.text;
    
    [[HRDataCenter sharedInstance]joinRequestWithUserID:signUpIDText password:signUpPasswordText password2:signUpPasswordCheckText completion:^(BOOL isSuccess, id response) {
        
        if (isSuccess == YES) {
            
            NSLog(@"로그인 성공 / token:::%@",response);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self signupSucessAlert];
                [self.joinIndicator stopAnimating];
                [self saveTodayDate];
                
            });

        } else {
            
            NSInteger reponseStatusCode = ((NSHTTPURLResponse *)response).statusCode; //response를 statusCode로 가져오는 것
            if (reponseStatusCode == 400) {
                
                NSLog(@"회원가입 실패 Error Code : %@", response);
                NSString *signupFailMessage = @"이메일 또는 비밀번호를 입력하세요. \n 또는 이미 등록된 사용자가 있습니다.";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self signupFailAlert:signupFailMessage];
                });
            
            }
            
            }
       
    }];
    [self.joinIndicator stopAnimating];
    
}

//회원가입 성공 alert
- (void)signupSucessAlert {
    
    UIAlertController *sucessAlert = [UIAlertController alertControllerWithTitle:@"성공" message:@"회원가입이 정상적으로 완료되었습니다." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [sucessAlert addAction:ok];
    [self presentViewController:sucessAlert animated:YES completion:nil];
}

//회원가입 실패 alert
- (void)signupFailAlert:(NSString *)failMessage {
    
    UIAlertController *sucessAlert = [UIAlertController alertControllerWithTitle:@"실패" message:failMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [sucessAlert addAction:ok];
    [self presentViewController:sucessAlert animated:YES completion:nil];
}

//오늘 날짜를 "YYYY-MM-dd" 형식으로 반환하는 메소드
- (void)saveTodayDate
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"YYYY-MM-dd"];
    NSString *today = [date stringFromDate:[NSDate date]];
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    HRRealmUser *user = [[HRRealmUser alloc] init];
//    user.signUpDate = today;
//    [realm beginWriteTransaction];
//    [realm addObject:user];
//    [realm commitWriteTransaction];
    [[NSUserDefaults standardUserDefaults] setValue:today forKey:@"signUpDate"];
    NSString * signUpDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"signUpDate"];
    NSLog(@"today = %@, signUpDate = %@",today, signUpDate);
}


//회원가입 페이지 뷰의 어느곳을 클릭해도 키보드 내리는 Method
#pragma mark- JoinTabGesture Method
- (IBAction)joinViewTabGesture:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little prparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
