//
//  HRCollectionViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRCollectionViewController.h"
#import "HRCollectionViewCell.h"
#import "AddViewController.h"

@interface HRCollectionViewController ()
<UICollectionViewDelegate, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryDirectButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraDirectButton;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonTrailing;


@property UISearchController *searchController;
@property NSString *searchText;
@property (strong, nonatomic) UIImage *pickedImage;

@end

@implementation HRCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

# pragma mark - Button Animation

- (IBAction)clickedAddButton:(UIButton *)sender {

    [self buttonAnimationWhenClicked];
};


- (IBAction)clickedBackgroundButton:(UIButton *)sender {
    
    [self buttonAnimationWhenClicked];
}

- (void)buttonAnimationWhenClicked {
    if (self.addButton.isSelected) {
        [self.addButton setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            
            [self settingAlphaForButtonAnimation:0 writeBtnAlpha:0 libraryBtnAlpha:0 cameraBtnAlpha:0];
            [self settingConstantForButtonAnimation:20 cameraBtnTrailing:20 libraryBtnBottom:self.addButtonBottom.constant libraryBtnTrailing:self.addButtonTrailing.constant];
            
            [self.addButton setSelected:NO];
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.addButton setImage:[UIImage imageNamed:@"addButtonSelected"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            
            NSUInteger buttonSize = self.addButton.frame.size.width;
            
            [self settingAlphaForButtonAnimation:0.3 writeBtnAlpha:1 libraryBtnAlpha:1 cameraBtnAlpha:1];
            [self settingConstantForButtonAnimation:buttonSize * 2.5 cameraBtnTrailing:buttonSize * 2.5 libraryBtnBottom:buttonSize * 1.8 libraryBtnTrailing:buttonSize * 1.8];
            
            [self.addButton setSelected:YES];
            [self.view layoutIfNeeded];
        }];
    }
};


# pragma mark - Supplementary Button Action

- (IBAction)clickedLibraryDirectButton:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary == YES]) {
        
        UIImagePickerController *libraryPicker = [[UIImagePickerController alloc] init];
        libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        libraryPicker.delegate = self;
        libraryPicker.allowsEditing = YES;
        
        [self presentViewController:libraryPicker animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"주의" message:@"사진 라이브러리에 접근할 수 없습니다. 설정을 다시 확인해주세요" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
    };
};

- (IBAction)clickedCameraDirectButton:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera == YES]) {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"주의" message:@"카메라에 접근할 수 없습니다. 설정을 다시 확인해주세요" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
    };
};

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(self.pickedImage, nil, nil, nil);
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segueFromLibrary" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFromLibrary"]) {
        UINavigationController *navi = (UINavigationController *)[segue destinationViewController];
        AddViewController *addViewContent = (AddViewController *)[[navi viewControllers] objectAtIndex:0];
        addViewContent.mainImageView.image = _pickedImage;
    }
    
//    self.addViewContent.mainImageView.image = imageSelected;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - Search Bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self resignFirstResponder];
    self.searchText = searchBar.text;
    self.navigationItem.title = self.searchText.uppercaseString;
}


#pragma mark - SUPPORTING METHODS

#pragma mark - Supporting button animation methods

- (void) settingAlphaForButtonAnimation:(CGFloat)backgroundAlpha
                          writeBtnAlpha:(CGFloat)writeAlpha
                        libraryBtnAlpha:(CGFloat)libraryAlpha
                         cameraBtnAlpha:(CGFloat)cameraAlpha {
    
    self.backgroundButton.alpha = backgroundAlpha;
    self.writeButton.alpha = writeAlpha;
    self.libraryDirectButton.alpha = libraryAlpha;
    self.cameraDirectButton.alpha = cameraAlpha;
}


- (void) settingConstantForButtonAnimation:(CGFloat)writeBtnConstant cameraBtnTrailing:(CGFloat)cameraBtnConstant libraryBtnBottom:(CGFloat)libraryBtnBottomConstant libraryBtnTrailing:(CGFloat)libraryBtnTrailingConstant {
    
    self.writeButtonBottom.constant = writeBtnConstant;
    self.cameraButtonTrailing.constant = cameraBtnConstant;
    self.libraryButtonBottom.constant = libraryBtnBottomConstant;
    self.libraryButtonTrailing.constant = libraryBtnTrailingConstant;
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
