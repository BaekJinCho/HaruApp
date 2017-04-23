//
//  HRCollectionViewController.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRCollectionViewController.h"

@interface HRCollectionViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *defaultPageImageView;
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
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property UIButton *trashBtn;
@property NSArray<NSIndexPath *> *indexPaths;
@property NSMutableArray *indexMutableArray;

@property (nonatomic) BOOL isDeleteMode;

@end

@implementation HRCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    collectionDataArray = [[HRRealmData allObjects] sortedResultsUsingKeyPath:@"date" ascending:NO]
    ;
    [_collectionView reloadData];
    
    if (collectionDataArray.count == 0) {
        self.defaultPageImageView.alpha = 1;
    } else {
        self.defaultPageImageView.alpha = 0;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setAllowsMultipleSelection:YES];

    
//    barButtonItem에 customView를 올려서 그 위에 UIButton을 올림
    self.trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trashBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [self.trashBtn setImage:[UIImage imageNamed:@"trashButton"] forState:UIControlStateNormal];
    [self.trashBtn setImage:[UIImage imageNamed:@"trashButtonSelected"] forState:UIControlStateSelected];
    [self.trashBtn addTarget:self action:@selector(trashBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    self.trashButton = [[UIBarButtonItem alloc]initWithCustomView:self.trashBtn];
    [self.navigationItem setLeftBarButtonItem:self.trashButton];
}

- (void) trashBtnSelected:(UIButton *)sender {
    if (sender.isSelected == YES) {
        
        [sender setSelected:NO];
        self.isDeleteMode = NO;
        [self.collectionView reloadData];
        
        NSLog(@"indexPaths : %@", self.indexPaths);
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSInteger i = 0 ; i <= self.indexPaths.count ; i++) {
            HRRealmData *info = [collectionDataArray objectAtIndex:self.indexPaths[i].item];
            [realm deleteObject:info];
        }
//        HRRealmData *info = [collectionDataArray objectAtIndex:self.indexPaths]
        [realm commitWriteTransaction];
        [self.collectionView reloadData];
//        [self.collectionView deleteItemsAtIndexPaths:self.indexPaths];
        
    } else {
        if (collectionDataArray.count == 0) {
            [self createAlertControllerWithTitle:@"주의" content:@"삭제할 데이터가 존재하지 않습니다" actionTitle:@"확인"];
        } else {
            [sender setSelected:YES];
            self.isDeleteMode = YES;
            [self.collectionView reloadData];
        }
    }
}


# pragma mark - CollectionView Delegate Methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width / 2.0, self.collectionView.frame.size.width / 2.0);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return collectionDataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    

    HRRealmData *info = [collectionDataArray objectAtIndex:indexPath.item];
    HRPostModel *postModel = [[HRPostModel alloc] init];
    
    cell.dateTextView.text = [postModel convertWithDate:info.date format:@"yyyy년 M월 dd일"];
    cell.titleTextView.text = info.title;
    cell.imageView.image = [UIImage imageWithData:info.mainImageData];
    
    if (self.isDeleteMode == YES) {
        cell.checkBox.alpha = 1;
    } else {
        cell.checkBox.alpha = 0;
    }
    
    return cell;
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.trashBtn.selected == NO) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HRMainView" bundle:nil];
        HRDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"HRDetailViewController"];
        
        detailViewController.indexPath = indexPath;
        detailViewController.realmData = [collectionDataArray objectAtIndex:indexPath.item];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else if (self.trashBtn.selected == YES) {
        HRCollectionViewCell *cell = (HRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.checkBox.selected) {
            [cell.checkBox setSelected:NO];
        } else {
            [cell.checkBox setSelected:YES];
            self.indexPaths = [collectionView indexPathsForSelectedItems];
        }
//        cell.checkBox.selected = cell.checkBox.selected ? NO : YES;
    }

    

}

# pragma mark - Button Animation

- (IBAction)clickedAddButton:(UIButton *)sender {

    [self buttonAnimationWhenClicked];
}


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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"경고" message:@"사진 라이브러리에 접근할 수 없습니다.\n 설정을 다시 확인해주세요" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
    };
};

- (IBAction)clickedCameraDirectButton:(UIImagePickerController *)picker {
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"경고" message:@"카메라에 접근할 수 없습니다.\n설정을 다시 확인해주세요" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil]; 
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
};

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.pickedImage = chosenImage;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(self.pickedImage, nil, nil, nil);
        });
    } else {
        NSLog(@"라이브러리 진입");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segueFromLibrary" sender:chosenImage];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFromLibrary"]) {
        UINavigationController *navi = (UINavigationController *)[segue destinationViewController];
        AddViewController *addViewContent = (AddViewController *)[[navi viewControllers] objectAtIndex:0];
//        AddViewController *addViewContent = (AddViewController *)segue.destinationViewController;
        UIImage *image = (UIImage *)sender;
        addViewContent.image = image;
        
    } else if ([segue.identifier isEqualToString:@"segueToDetailView"]) {
        UINavigationController *navi2 = (UINavigationController *)[segue destinationViewController];
        HRDetailViewController *detailViewContent = (HRDetailViewController *)[[navi2 viewControllers] objectAtIndex:0];
        detailViewContent.indexPath               = (NSIndexPath *)sender;
        detailViewContent.realmData = [collectionDataArray objectAtIndex:((NSIndexPath *)sender).item];
    }
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

- (void)createAlertControllerWithTitle:(NSString *)title
                               content:(NSString *)content
                           actionTitle:(NSString *)actionTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
