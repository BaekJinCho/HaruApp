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

@end

@implementation HRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //loginPasswordTextField *로 표시
    self.LoginPasswordTextField.secureTextEntry = YES;
    
    //UIView 투명 만들어주기!
    self.loginContentView.opaque = NO;
    self.loginContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    //notification으로 loginScrollView 올리기!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChaneLoginScrollView:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChaneLoginScrollView:) name:UIKeyboardWillShowNotification object:nil];
    
    
    
    
}
//notification으로 loginScrollView 올리는 Method
#pragma mark- loginView notification Method
- (void)didChaneLoginScrollView:(NSNotification *) notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [self.loginScrollView setContentOffset:CGPointMake(0, keyboardRect.size.height-170) animated:YES];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    NSLog(@"%lf", keyboardRect.size.width);
    
}
//notification dealloc
#pragma mark- signupView notification dealloc Method
- (void)dealloc {
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
    }
    return YES;
}

- (IBAction)clickLoginButton:(UIButton *)sender {
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
