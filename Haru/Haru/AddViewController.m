//
//  AddViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 4. 3..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "AddViewController.h"

static NSInteger const TITLE_MAXLENGTH = 10;
static NSInteger const CONTEXT_MAXLENGTH = 120;

@interface AddViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *contextTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *emoticonImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekOfDayLabel;

@property (nonatomic) UIBarButtonItem *happyBarButton;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleTextView.tag = 1;
    self.contextTextView.tag = 2;
    
}



- (void)viewDidAppear:(BOOL)animated {
    
//    [self.titleTextView becomeFirstResponder];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *happyBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Happy"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *sadBarButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"Sad"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    
    UIBarButtonItem *angryBarButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"Angry"] style:UIBarButtonItemStylePlain target:nil action:@selector(addEmoticon)];
    
    keyboardToolbar.items = @[happyBarButton, flexBarButton, sadBarButton, flexBarButton, angryBarButton];
    
    [self.titleTextView setInputAccessoryView:keyboardToolbar];
}

- (void)addEmoticon {
    
    self.emoticonImageView.image = self.happyBarButton.image;
    
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
    
    // 촬영한 이미지를 포토 라이브러리에 저장하는 메소드
//    UIImageWriteToSavedPhotosAlbum(self.mainImageView.image, self, @selector(didFinishSavingWithError), nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// imagePicker 뷰에서 cancel 버튼을 눌렸을 때 실행 되는 메소드
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    int allowedLength = 0;
    switch(textView.tag) {
        case 1:
            allowedLength = TITLE_MAXLENGTH;      // triggered for input fields with tag = 1
            break;
        case 2:
            allowedLength = CONTEXT_MAXLENGTH;   // triggered for input fields with tag = 2
            break;
    }
    
    if (textView.text.length >= allowedLength && range.length == 0) {
        return NO; // Change not allowed
    } else {
        return YES; // Change allowed
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
