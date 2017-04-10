//
//  HRCollectionViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRCollectionViewController.h"

@interface HRCollectionViewController ()
<UICollectionViewDelegate, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryDirectButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraDirectButton;

@property CGPoint addButtonCenter;
@property CGPoint writeButtonCenter;
@property CGPoint libraryDirectButtonCenter;
@property CGPoint cameraDirectButtonCenter;

@end

@implementation HRCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButtonCenter = self.addButton.center;
    self.writeButtonCenter = self.writeButton.center;
    self.libraryDirectButtonCenter = self.libraryDirectButton.center;
    self.cameraDirectButtonCenter = self.cameraDirectButton.center;
    
    self.writeButton.center = self.addButton.center;
    self.libraryDirectButton.center = self.addButton.center;
    self.cameraDirectButton.center = self.addButton.center;
    
}


- (IBAction)clickedAddButton:(UIButton *)sender {
    
    if(self.addButton.isSelected) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.writeButton.alpha = 0;
            self.libraryDirectButton.alpha = 0;
            self.cameraDirectButton.alpha = 0;
            
            self.writeButton.center = self.addButton.center;
            self.libraryDirectButton.center = self.addButton.center;
            self.cameraDirectButton.center = self.addButton.center;
            
            [self.addButton setSelected:NO];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.writeButton.alpha = 1;
            self.libraryDirectButton.alpha = 1;
            self.cameraDirectButton.alpha = 1;
            
            self.writeButton.center = self.writeButtonCenter;
            self.libraryDirectButton.center = self.libraryDirectButtonCenter;
            self.cameraDirectButton.center = self.cameraDirectButtonCenter;
            
            [self.addButton setSelected:YES];
        }];
    }
    [self toggleButton:sender normalImage:[UIImage imageNamed:@"AddButton"] selectedImage:[UIImage imageNamed:@"addButtonSelected"]];
};


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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)toggleButton:(UIButton *)button normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    
    if(self.addButton.isSelected) {
        [button setImage:selectedImage forState:UIControlStateNormal];
    } else {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
};



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
