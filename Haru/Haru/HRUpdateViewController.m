//
//  HRModifiedViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 4. 3..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRUpdateViewController.h"
#import "HRMainViewController.h"

@interface HRUpdateViewController ()
<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView         *postUpdateTextView;
@property (weak, nonatomic) IBOutlet UITextField        *postTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView        *updateViewUserStateImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *updateViewBackgroundPhoto;
@property (weak, nonatomic) IBOutlet UILabel            *updateViewDayLabel;
@property (weak, nonatomic) IBOutlet UILabel            *updateViewDayOfWeekLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postViewContentTextVIewBottomConstant;

@property (nonatomic) NSArray                           *userStateEmoticonArrays;
@property (nonatomic) NSMutableArray                    *emoticonArrays;
@property (nonatomic) UIBarButtonItem                   *userStateEmoticonButton;
@property (nonatomic) NSInteger tagNum;

@end

@implementation HRUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.postModel = [[HRPostModel alloc] init];
    
    //notification으로 modifiedViewController ContentView 올리기 위한 NotificationCenter 구현
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //textField의 내용을 변경해줄 때, 제한을 두기 위해 구현
    [self.postTitleTextField addTarget:self action:@selector(fixPostTitleTextLength:) forControlEvents:UIControlEventEditingChanged];
    
    
    //UIToolbar 생성 및 Item 넣어주는 작업
    [self inputEmoticonAccessoryView];
    
    /***************************************Server 통신할 때 적용************************************************/
//    //메인 페이지에 있는 데이터 넘겨주기
//    if (self.postModel == nil) {
//        NSLog(@"Error : 수정화면에 데이터가 없습니다.");
//    } else {
//        
//        self.postTitleTextField.text            = self.postModel.title;
//        self.postUpdateTextView.text            = self.postModel.content;
//        self.updateViewUserStateImageView.image = [UIImage imageNamed:self.postModel.userStateImage];
//        self.updateViewDayLabel.text            = [self.postModel convertWithDate:self.postModel.totalDate format:@"dd"];
//        self.updateViewDayOfWeekLabel.text      = [self.postModel convertWithDate:self.postModel.totalDate format:@"E"];
//        [self.updateViewBackgroundPhoto sd_setImageWithURL:[NSURL URLWithString:self.postModel.photo]
//                                          placeholderImage:[UIImage imageNamed:@""]];
//        
//    }
    /**********************************************************************************************************/
    if (self.realmData == nil) {
        NSLog(@"Error : realm에 데이터가 없습니다.");
    } else {
        
        NSLog(@"현재 데이터 : %@", self.realmData);
        self.postTitleTextField.text            = self.realmData.title;
        self.postUpdateTextView.text            = self.realmData.content;
        self.updateViewDayLabel.text            = [self.postModel convertWithDate:self.realmData.date format:@"dd"];
        self.updateViewDayOfWeekLabel.text      = [self.postModel convertWithDate:self.realmData.date format:@"E요일"];
        self.updateViewBackgroundPhoto.image    = [UIImage imageWithData:self.realmData.mainImageData];
        self.updateViewUserStateImageView.image = [self.postModel retrieveUserState:self.realmData.emoticonValue];
        
    }
}

//UIToolbar 생성 및 Item 넣어주는 작업
- (void)inputEmoticonAccessoryView {
    
    [self.postUpdateTextView becomeFirstResponder];
    
    UIToolbar *keyboardToolbar   = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    self.userStateEmoticonArrays = @[@"Happy", @"Sad", @"Angry", @"Soso", @"Upset", @"cameraBarButton", @"libraryBarButton"];
    
    self.emoticonArrays          = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0 ; i < self.userStateEmoticonArrays.count ; i++) {
        
        self.userStateEmoticonButton   = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:self.userStateEmoticonArrays[i]]
                                        style:UIBarButtonItemStylePlain
                                        target:self action:@selector(addEmoticon:)];
        [self.userStateEmoticonButton setTintColor:[UIColor colorWithRed:107/255.0 green:108/255.0 blue:103/255.0 alpha:1]];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        
        [self.emoticonArrays addObject:self.userStateEmoticonButton];
        if (i==4) {
            [self.emoticonArrays addObject:flexBarButton];
            
        }
        
        [self.emoticonArrays addObject:flexBarButton];
        self.userStateEmoticonButton.tag = i;
    }
    [self.emoticonArrays removeLastObject];
    keyboardToolbar.items                      = self.emoticonArrays;
    self.postUpdateTextView.inputAccessoryView = keyboardToolbar;

}


//UIBarButtonItem Selector Method (barbutton item을 클릭할 때마다 이모티콘 및 행동이 바뀌는 로직 처리)
- (void)addEmoticon:(UIBarButtonItem *)clickUserStateBarButtonItem {
    
    if (clickUserStateBarButtonItem.tag == 0) {
        
        [self.updateViewUserStateImageView setImage:[UIImage imageNamed:@"Happy"]];
        NSLog(@"%@", self.updateViewUserStateImageView.image);
        self.tagNum = clickUserStateBarButtonItem.tag;
        
    } else if (clickUserStateBarButtonItem.tag == 1) {
        
        [self.updateViewUserStateImageView setImage:[UIImage imageNamed:@"Sad"]];
        NSLog(@"%@", self.updateViewUserStateImageView.image);
        self.tagNum = clickUserStateBarButtonItem.tag;

    
    } else if (clickUserStateBarButtonItem.tag == 2) {
        
        [self.updateViewUserStateImageView setImage:[UIImage imageNamed:@"Angry"]];
        NSLog(@"%@", self.updateViewUserStateImageView.image);
        self.tagNum = clickUserStateBarButtonItem.tag;

    
    } else if (clickUserStateBarButtonItem.tag == 3) {
        
        [self.updateViewUserStateImageView setImage:[UIImage imageNamed:@"Upset"]];
        NSLog(@"%@", self.updateViewUserStateImageView.image);
        self.tagNum = clickUserStateBarButtonItem.tag;

    
    } else if (clickUserStateBarButtonItem.tag == 4) {
        
        [self.updateViewUserStateImageView setImage:[UIImage imageNamed:@"Soso"]];
        NSLog(@"%@", self.updateViewUserStateImageView.image);
        self.tagNum = clickUserStateBarButtonItem.tag;

    
    } else if (clickUserStateBarButtonItem.tag == 5) {
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.sourceType    = UIImagePickerControllerSourceTypeCamera;
        cameraController.allowsEditing = YES;
        cameraController.delegate      = self;
        [self presentViewController:cameraController animated:YES completion:nil];
        
    } else if (clickUserStateBarButtonItem.tag == 6) {
        
        UIImagePickerController *photoLibraryController = [[UIImagePickerController alloc] init];
        photoLibraryController.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        photoLibraryController.allowsEditing = YES;
        photoLibraryController.delegate      = self;
        [self presentViewController:photoLibraryController animated:YES completion:nil];
       
    }
}

//Image의 선택이 끝났을 때, 불리는 Method
#pragma mark- UpdateViewController UIImagePicker Delegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info %@", info);
    self.updateViewBackgroundPhoto.image = [info objectForKey:UIImagePickerControllerEditedImage];;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
#pragma mark- UpdateViewController TextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self.postTitleTextField resignFirstResponder];
    }
    return YES;
}

//TextField의 Content를 입력할 때마다 불리는 Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    return !([textField.text length] > MAX_POST_TITLE_CONTENT && [string length] > range.length);
}

////TextField의 Content를 변경하고자 할 때, Method

- (void)fixPostTitleTextLength:(UITextField *)titleTextField {
    
    NSString *textFieldContentText = titleTextField.text;
    NSInteger textFieldContentLength = titleTextField.text.length;
    
    if (textFieldContentLength > MAX_POST_TITLE_CONTENT) {
        titleTextField.text = [textFieldContentText substringToIndex:MAX_POST_TITLE_CONTENT];
        //alert 띄어줄까? 고민중..
    }
    
}

//TextView의 Content를 입력할 때마다 불리는 Method
#pragma mark- UpdateViewController TextView Delegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //alert 띄어줄까? 고민중...
    return !([textView.text length] > MAX_POST_CONTENT && [text length] > range.length);
}


//글 내용을 복사한 내용을 변경했을 때, 불리는 Method

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *textViewContentText = textView.text;
    NSInteger textViewContentLength = textView.text.length;
    
    if (textViewContentLength > MAX_POST_CONTENT) {
        textView.text = [textViewContentText substringToIndex:MAX_POST_CONTENT];
        //alert 띄어줄까? 고민중..
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.postUpdateTextView.tag == 2) {
        [self.postUpdateTextView endEditing:YES];
    }
}

//수정화면에서 뒤로가기를 클릭했을 때, 불리는 Method
#pragma mark- UpdateViewController UIBarButtonItem Method
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

//저장 버튼 클릭했을 때 불리는 Method

- (IBAction)clickSaveNavigationBarButton:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"clickSaveButton" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //수정한 내용을 서버에 보내주는 작업 필요 & Main, Detail View에도 적용하는 작업 필요
//    HRPostModel *test = [HRDataCenter sharedInstance]updateDiaryContent:<#(NSIndexPath *)#> haruContentsData:<#(HRPostModel *)#>
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        self.realmData.title = self.postTitleTextField.text;
        self.realmData.content = self.postUpdateTextView.text;
        self.realmData.mainImageData = UIImagePNGRepresentation(self.updateViewBackgroundPhoto.image);
        self.realmData.emoticonValue = self.tagNum;
        
        
    }];
    
}

//수정하는 페이지 뷰의 어느곳을 클릭해도 키보드 내리는 Method
#pragma mark- UpdateViewController UITabeGesture Method
- (IBAction)modifiedViewTabGesture:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

//notification dealloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
