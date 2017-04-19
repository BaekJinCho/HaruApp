//
//  HRUserViewController.m
//  Haru
//
//  Created by SSangGA on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRUserViewController.h"
#import "HRUserAFNetworkingModule.h"
#import "FSCalendar.h"
#import "HRRealmData.h"


@interface HRUserViewController ()
<UITextFieldDelegate,UIImagePickerControllerDelegate,FSCalendarDelegate,FSCalendarDataSource, UINavigationControllerDelegate>
@property HRUserAFNetworkingModule *networkManager;
@property HRDataCenter *dataManager;
@property FSCalendar *calendrManager;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *count_post;
@property (weak, nonatomic) IBOutlet UILabel *count_streaks;
@property (weak, nonatomic) IBOutlet UILabel *date_join;
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

@implementation HRUserViewController

- (void)viewDidAppear:(BOOL)animated {
    RLMResults <HRRealmData *> *result = [HRRealmData allObjects];
    
    NSLog(@"%@", [result lastObject]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPostCountToLabel];
    
    self.networkManager = [[HRUserAFNetworkingModule alloc] init];
    
    
    HRRealmData *result = nil;
}


//FSCalendar 날짜 아래 표시 글(subtitle)
-(NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSString *subtitle = @"P";
    return subtitle;
}


- (IBAction)didClickedUserProfileImage:(UIButton *)sender
{   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"프로필 사진 선택" message:@"마음에 드는 사진을 선택하세요" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *camController = [[UIImagePickerController alloc] init];
        camController.sourceType = UIImagePickerControllerSourceTypeCamera;
        camController.allowsEditing = YES;
        camController.mediaTypes
        = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        camController.delegate = self;
        
        [self presentViewController:camController animated: YES completion: nil];
    }];
    
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"라이브러리" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
        libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        libraryController.allowsEditing = YES;
        libraryController.delegate = self;
        
        [self presentViewController:libraryController animated:YES completion:nil];
    }];
    
    [alertController addAction:alertAction];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.avatar setImage:image];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
    } else {
        NSLog(@"라이브러리 진입");
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        
    }];
    
//    [realm beginWriteTransaction];
//    
//    self.userInfo.photoData = imageData;
//    
//    [realm commitWriteTransaction];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didClickedLogoutBtn:(id)sender
{
    [self logoutSucessAlert];
    
}

//로그아웃 후 alert
- (void)logoutSucessAlert {
    NSString *tokenValue = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    NSLog(@"%@",tokenValue);
    
    
    [self.networkManager logoutRequest:tokenValue completion:^(BOOL Sucess, NSHTTPURLResponse *ResponseData) {
        if (Sucess) {
            UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"로그아웃" message:@"정상적으로 로그아웃 되었습니다" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Logout Alert");
//                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"HRTutorial" bundle:nil];
//                self.view.window.rootViewController = [mainStoryboard instantiateInitialViewController]
                [self.tabBarController performSegueWithIdentifier:@"showTutorial" sender:nil];
            }];
            [logoutAlert addAction:okBtn];
            [self presentViewController:logoutAlert animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY_OF_USERDEFAULTS];
        }
    }];
}

// 쓴글 표시를 위해 postlistRequest메소드 호출하여 count키값만 추출하여 count_post.text에 삽입
-(void)getPostCountToLabel
{
    __block NSString *result = [[NSString alloc] init];
     [self.networkManager postListRequest:^(BOOL Sucess, NSDictionary *ResponseData) {
        result = [ResponseData objectForKey:@"count"];
    }];
    self.count_post.text = result;
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
