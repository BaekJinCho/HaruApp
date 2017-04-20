//
//  AddViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 4. 3..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import "AddViewController.h"
#import "HRRealmData.h"

static NSInteger TITLE_MAXLENGTH = 20;
static NSUInteger CONTENT_MAXLENGTH = 150;

@interface AddViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic) UIBarButtonItem *happyBarButton;
@property (nonatomic) NSArray *emoticonArray;
@property (nonatomic) NSMutableArray *barButtonArray;
@property (nonatomic) UIBarButtonItem *emoticonBarButton;
@property NSDate *currentDate;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mainImageView.image = self.image;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.emoticonArray = @[@"Happy", @"Sad", @"Angry", @"Upset", @"Soso"];
    
    self.contentTextView.textContainer.maximumNumberOfLines = 4;
    self.contentTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    self.titleTextView.tag = 1;
    self.contentTextView.tag = 2;
    self.titleTextView.placeholder = @"제목을 입력하세요";
    self.contentTextView.placeholder = @"내용을 입력하세요";
    
//    데이트 불러오기
    self.currentDate = [NSDate date];

    NSLocale *koreanLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    NSTimeZone *koreanTime = [[NSTimeZone alloc] initWithName:@"KST"];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setLocale:koreanLocale];
    [dayFormatter setTimeZone:koreanTime];
    [dayFormatter setDateFormat:@"d"];
    
    NSDateFormatter *weekDayFormatter = [[NSDateFormatter alloc] init];
    [weekDayFormatter setLocale:koreanLocale];
    [weekDayFormatter setTimeZone:koreanTime];
    [weekDayFormatter setDateFormat:@"EEEE"];
    
    NSString *day = [dayFormatter stringFromDate:self.currentDate];
    NSString *weekDay = [weekDayFormatter stringFromDate:self.currentDate];
    
    self.dayLabel.text = day;
    self.weekOfDayLabel.text = weekDay;

    [self createToolBar];
    [self.titleTextView becomeFirstResponder];
    

}

- (void) createToolBar {
    
    NSUInteger i;
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    self.barButtonArray = [[NSMutableArray alloc] init];
    
    for (i = 0; i < self.emoticonArray.count; i++) {

        self.emoticonBarButton = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:[self.emoticonArray objectAtIndex:i]] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon:)];
        
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        self.emoticonBarButton.tag = i;
        
        [self.barButtonArray addObject:self.emoticonBarButton];
        [self.barButtonArray addObject:flexBarButton];
    }
    
    [self.barButtonArray removeLastObject];
    keyboardToolbar.items = self.barButtonArray;
    [self.titleTextView setInputAccessoryView:keyboardToolbar];
    [self.contentTextView setInputAccessoryView:keyboardToolbar];
    keyboardToolbar.tintColor = [UIColor grayColor];
}


- (IBAction)clickedSaveButton:(id)sender {
    
    
    [self insertDataIntoDataBaseWithTitle:self.titleTextView.text content:self.contentTextView.text mainImage:self.mainImageView.image date:self.currentDate];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickedBackButton:(id)sender {
    if ([self.titleTextView isFirstResponder]) {
        [self.view endEditing:YES];
    } else if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    };

//    Resign all editing features including the keyboard
//    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)addEmoticon:(UIBarButtonItem *)emoticonBarButtonItem {
    
    switch (emoticonBarButtonItem.tag) {
        case 0:
            [self.emoticonImageView setImage:emoticonBarButtonItem.image];
            break;
        case 1:
            [self.emoticonImageView setImage:emoticonBarButtonItem.image];
            break;
        case 2:
            [self.emoticonImageView setImage:emoticonBarButtonItem.image];
            break;
        case 3:
            [self.emoticonImageView setImage:emoticonBarButtonItem.image];
            break;
        case 4:
            [self.emoticonImageView setImage:emoticonBarButtonItem.image];
            break;
        default:
            break;
    }
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
    NSTimeInterval timeInterval = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self.keyboardHeight setConstant:100];
    self.buttonViewHeight.constant = 0;
    [self.backgroundView setNeedsUpdateConstraints];
    [self.buttonView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:timeInterval animations:^{
        [self.backgroundView layoutIfNeeded];
        [self.buttonView layoutIfNeeded];
    }];
}

- (IBAction)tapToRemoveKeyboard:(UITapGestureRecognizer *)tapGesture {
    
    [self.view endEditing:YES];
}


#pragma mark - camera/photo related methods

// 카메라 버튼 눌렸을 때, 카메라 뷰를 실행시키는 메소드
- (IBAction)touchedCameraButton:(UIImagePickerController *)picker {
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        
    [self presentViewController:cameraPicker animated:YES completion:nil];
    } else {
        NSLog(@"Camera Not Available!!");
    }
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
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
    };

    [self dismissViewControllerAnimated:YES completion:nil];
}


// imagePicker 뷰에서 cancel 버튼을 눌렸을 때 실행 되는 메소드
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textView Related Methods

// 텍스트 뷰가 수정될 때마
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    switch (textView.tag) {
        case 1: {
            NSString *newText = [textView.text stringByReplacingCharactersInRange: range withString: text];
            [self adjustContentSizeOfTextView:textView];

            if( [newText length] <= TITLE_MAXLENGTH){
                
                return YES;
            }
            // 타이틀 텍스트 길이가 최대수치 이상일 때 불릴 때 no를 반환해준다. 
            textView.text = [newText substringToIndex: TITLE_MAXLENGTH];

            return NO;
            break;
        }
        default: {
            NSString *newText = [textView.text stringByReplacingCharactersInRange: range withString: text];
            textView.textContainer.maximumNumberOfLines = 4;
            textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [self adjustContentSizeOfTextView:textView];

            if( [newText length] <= CONTENT_MAXLENGTH){
                return YES;
            }
            // case where text length > MAX_LENGTH
            textView.text = [newText substringToIndex: CONTENT_MAXLENGTH];
            return NO;
            break;
        }
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)adjustContentSizeOfTextView:(UITextView*)textView {
    CGFloat textViewSpace = ([textView bounds].size.height - [textView contentSize].height);
    CGFloat inset = MAX(0, textViewSpace/2.0);
    textView.contentInset = UIEdgeInsetsMake(inset, textView.contentInset.left, inset, textView.contentInset.right);
}

- (void)viewWillAppear:(BOOL)animated {
    [self adjustContentSizeOfTextView:self.titleTextView];
    [self adjustContentSizeOfTextView:self.contentTextView];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    
//    [self adjustContentSizeOfTextView:textView];
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    [self adjustContentSizeOfTextView:textView];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self adjustContentSizeOfTextView:textView];
//}

#pragma mark - Realm Methods 

- (void)insertDataIntoDataBaseWithTitle:(NSString *)title
                                content:(NSString *)content
                              mainImage:(UIImage *)mainImage
                                   date:(NSDate *)date {
    
    NSData *imageData = [[NSData alloc] init];
    imageData = UIImagePNGRepresentation(mainImage);
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    HRRealmData *info = [[HRRealmData alloc] init];
    info.title = title;
    info.content = content;
    info.mainImageData = imageData;
    info.date = date;
//    info.emoticonValue = emoticonValue;
    [realm addObject:info];
    [realm commitWriteTransaction];
}

- (void)createAlertControllerWithTitle:(NSString *)title
                               content:(NSString *)content
                           actionTitle:(NSString *)actionTitle
                           actionStyle:(UIAlertActionStyle *)actionStyle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle style:*actionStyle handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:alertAction];
    
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
