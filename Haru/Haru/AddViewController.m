//
//  AddViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 4. 3..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "AddViewController.h"

static NSInteger TITLE_MAXLENGTH = 10;
static NSUInteger CONTENT_MAXLENGTH = 120;

@interface AddViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *contextTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *emoticonImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekOfDayLabel;

@property (nonatomic) UIBarButtonItem *happyBarButton;
@property (nonatomic) NSArray *emoticonArray;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    self.emoticonArray = @[@"Happy", @"Sad", @"Angry", @"Upset", @"Soso"];
    
    self.titleTextView.tag = 1;
    self.contextTextView.tag = 2;
    
    self.dayLabel.numberOfLines = 1;
    self.dayLabel.minimumScaleFactor = 20;
    self.dayLabel.adjustsFontSizeToFitWidth = YES;
    
    self.weekOfDayLabel.numberOfLines = 1;
    self.weekOfDayLabel.minimumScaleFactor = 10;
    self.weekOfDayLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [self.titleTextView becomeFirstResponder];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *happyBarButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"Happy"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    happyBarButton.tag = 11;
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *sadBarButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"Sad"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    flexBarButton.tag = 22;
    
    UIBarButtonItem *angryBarButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"Angry"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    flexBarButton.tag = 33;

    
    UIBarButtonItem *upsetBarButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"Upset"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    flexBarButton.tag = 44;

    
    UIBarButtonItem *sosoBarButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"Soso"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    flexBarButton.tag = 55;

    
    
    keyboardToolbar.items = @[happyBarButton, flexBarButton, sadBarButton, flexBarButton, angryBarButton, flexBarButton, upsetBarButton, flexBarButton, sosoBarButton];
    
    
    [self.titleTextView setInputAccessoryView:keyboardToolbar];
    [self.contextTextView setInputAccessoryView:keyboardToolbar];
}


- (void)addEmoticon {
    
    self.emoticonImageView.image = [UIImage imageNamed:[_emoticonArray objectAtIndex:1]];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval timeInterval = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    self.keyboardHeight.constant = +height + 30;
    self.buttonViewHeight.constant = +height;
    [self.backgroundView setNeedsUpdateConstraints];
    [self.buttonView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:timeInterval animations:^{
        [self.backgroundView layoutIfNeeded];
        [self.buttonView layoutIfNeeded];
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval timeInterval = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    self.keyboardHeight.constant = height;
    self.buttonViewHeight.constant = 0;
    [self.backgroundView setNeedsUpdateConstraints];
    [self.buttonView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:timeInterval animations:^{
        [self.backgroundView layoutIfNeeded];
        [self.buttonView layoutIfNeeded];
    }];
}


// 데이터를 realm에 저장하는 메소드
//- (IBAction)clickedSaveButton:(id)sender {
//
//    NSString *title = self.titleTextView.text;
//    NSString *context = self.contextTextView.text;
//    UIImage *mainImage = self.mainImgView.image;
//    UIImage *emoticonImage = self.emoticonImgView.image;
//
//    [[HRPostDataCenter sharedPostInstance] insertDataIntoDataBaseWithName:title context:context mainImage:mainImage emoticonImage:emoticonImage];
//}


#pragma mark - camera/photo related methods

// 카메라 버튼 눌렸을 때, 카메라 뷰를 실행시키는 메소드
- (IBAction)touchedCameraButton:(id)sender {
    
    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    
    [self presentViewController:cameraPicker animated:YES completion:nil];
}


// 사진 버튼을 눌렸을 떄, 포토 라이브러리 뷰를 실행시키는 메소드
- (IBAction)touchedPhotoButton:(id)sender {
    
    UIImagePickerController *libraryPicker = [[UIImagePickerController alloc] init];
    libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    libraryPicker.delegate = self;
    libraryPicker.allowsEditing = YES;
    
    [self presentViewController:libraryPicker animated:YES completion:nil];
}


// 이미지를 고른 후, imagePicker 뷰를 내리고 기타 기능을 실행시키는 메소드
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.mainImageView.image = image;
    

//    UIImageWriteToSavedPhotosAlbum(self.mainImageView.image, self, @selector(didFinishSavingWithError), nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


// imagePicker 뷰에서 cancel 버튼을 눌렸을 때 실행 되는 메소드
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - text related methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    switch (textView.tag) {
        case 1: {
            NSString *newText = [textView.text stringByReplacingCharactersInRange: range withString: text];
            if( [newText length] <= TITLE_MAXLENGTH){
                return YES;
            }
            // case where text length > MAX_LENGTH
            textView.text = [newText substringToIndex: TITLE_MAXLENGTH];
            return NO;
            break;
        }
        default: {
            NSString *newText = [textView.text stringByReplacingCharactersInRange: range withString: text];
            if( [newText length] <= CONTENT_MAXLENGTH){
                return YES;
            }
            // case where text length > MAX_LENGTH
            textView.text = [newText substringToIndex: CONTENT_MAXLENGTH];
            return NO;
            break;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
