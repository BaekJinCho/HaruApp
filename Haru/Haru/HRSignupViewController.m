//
//  HRSignupViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRSignupViewController.h"

@interface HRSignupViewController ()
<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *signupContentView;
@property (weak, nonatomic) IBOutlet UITextField *signupIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordCheckTextField;

@end

@implementation HRSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIView 투명 만들어주기!
    self.signupContentView.opaque = NO;
    self.signupContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- signupView TextField ShouldReturn Method
//텍스트 필드에서 return 클릭했을 때, 불리는 delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [self.signupPasswordTextField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.signupPasswordCheckTextField becomeFirstResponder];
    } else
        [self.signupPasswordCheckTextField resignFirstResponder];
    return YES;
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
