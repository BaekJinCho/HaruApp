//
//  HRModifiedViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 4. 3..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRUpdateViewController.h"
#import "HRMainViewController.h"

static NSUInteger MAX_POST_TITLE_CONTENT = 13; //일기 제목의 글자 제한 주기위한 변수
static NSUInteger MAX_POST_CONTENT = 110; //일기 내용의 글자 제한 주기위한 변수


@interface HRUpdateViewController ()
<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *postUpdateTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postViewContentTextVIewBottomConstant;
@property (weak, nonatomic) IBOutlet UITextField *postTitleTextField;

@end

@implementation HRUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //notification으로 modifiedViewController ContentView 올리기 위한 NotificationCenter 구현
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //textField의 내용을 변경해줄 때, 제한을 두기 위해 구현
    [self.postTitleTextField addTarget:self action:@selector(fixPostTitleTextLenth:) forControlEvents:UIControlEventEditingChanged];
    
//    self.modifiedTextView.textContainer.maximumNumberOfLines = 1;
//    self.modifiedTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingHead;
}

//UIToolbar 생성 및 Item 넣어주는 작업
#pragma mark- ViewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    
    [self.postUpdateTextView becomeFirstResponder];

    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    

 
    NSArray *userStateEmoticonArrays = @[@"Happy", @"Sad", @"Angry", @"Soso", @"Upset", @"cameraButton", @"libraryButton"];
    NSMutableArray *EmoticonArrays = [[NSMutableArray alloc] init];
    
    for (NSString *userStateString in userStateEmoticonArrays) {
        UIBarButtonItem *userStateEmoticonButton = [[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:userStateString]
                                           style:UIBarButtonItemStylePlain
                                           target:nil action:@selector(addEmoticon:)];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        
        [EmoticonArrays addObject:userStateEmoticonButton];
        [EmoticonArrays addObject:flexBarButton];


    }
    [EmoticonArrays removeLastObject];
    keyboardToolbar.items = EmoticonArrays;

    self.postUpdateTextView.inputAccessoryView = keyboardToolbar;
}

//UIBarButtonItem Selector Method
#pragma mark- UIBarButtonItem Selector Method
- (void)addEmoticon:(UIBarButtonItem *) sender{
}

//ContentView의 Constraints를 키보드의 높이만큼 올리기 위한 Method
#pragma mark- UpdateViewController NSNotification Method
- (void)keyboardDidShow:(NSNotification *)sender {
    CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect newFrame = [self.view convertRect:frame fromView:[[UIApplication sharedApplication] delegate].window];
    
    CGFloat bottom = self.postViewContentTextVIewBottomConstant.constant;
    if (bottom == 0) {
        self.postViewContentTextVIewBottomConstant.constant += CGRectGetHeight(frame);
    }
    [self.view layoutIfNeeded];
}

//ContentView의 Constraints를 키보드의 높이만큼 내리기 위한 Method
#pragma mark- UpdateViewController NSNotification Method
- (void)keyboardWillHide:(NSNotification *)sender {
    CGFloat bottom = self.postViewContentTextVIewBottomConstant.constant;
    if (bottom != 0) {
    self.postViewContentTextVIewBottomConstant.constant = 0;
    }
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//return button을 클릭했을 때, 불리는 Method
#pragma mark- UpdateViewController TextFieldShouldReturn Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self.postTitleTextField resignFirstResponder];
    }
    return YES;
}

//TextField의 Content를 입력할 때마다 불리는 Method
#pragma mark- UpdateViewController TextField ShouldChangeTextInRange Delegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    return !([textField.text length] > MAX_POST_TITLE_CONTENT && [string length] > range.length);
}

////TextField의 Content를 변경하고자 할 때, Method
#pragma mark- UpdateViewController fixPostTitleTextLenth Method
- (void)fixPostTitleTextLenth:(UITextField *)titleTextField {
    
    NSString *textFieldContentText = titleTextField.text;
    NSInteger textFieldContentLength = titleTextField.text.length;
    
    if (textFieldContentLength > MAX_POST_TITLE_CONTENT) {
        titleTextField.text = [textFieldContentText substringToIndex:MAX_POST_TITLE_CONTENT];
        //alert 띄어줄까? 고민중..
    }
    
}

//TextView의 Content를 입력할 때마다 불리는 Method
#pragma mark- UpdateViewController TextView ShouldChangeTextInRange Delegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //alert 띄어줄까? 고민중...
    return !([textView.text length] > MAX_POST_CONTENT && [text length] > range.length);
}

 


//글 내용을 복사한 내용을 변경했을 때, 불리는 Method
#pragma mark - UpdateViewController Textview didChange Delegate Method
- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *textViewContentText = textView.text;
    NSInteger textViewContentLength = textView.text.length;
    
    if (textViewContentLength > MAX_POST_CONTENT) {
        textView.text = [textViewContentText substringToIndex:MAX_POST_CONTENT];
        //alert 띄어줄까? 고민중..
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (self.postUpdateTextView.tag == 2) {
        [self.postUpdateTextView endEditing:YES];
    }
}

//수정화면에서 뒤로가기를 클릭했을 때, 불리는 Method
#pragma mark- UpdateViewController BackButton Method
- (IBAction)backDetailViewButton:(UIBarButtonItem *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"주의" message:@"저장하지 않고 종료하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
         }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

//수정하는 페이지 뷰의 어느곳을 클릭해도 키보드 내리는 Method
#pragma mark- UpdateViewController Method
- (IBAction)modifiedViewTabGesture:(UITapGestureRecognizer *)sender {
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
