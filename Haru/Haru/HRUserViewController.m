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
#import "HRJoinViewController.h"

@interface HRUserViewController ()
<UITextFieldDelegate,UIImagePickerControllerDelegate,FSCalendarDelegate,FSCalendarDataSource, UINavigationControllerDelegate,UITabBarDelegate>

{
    RLMResults <HRRealmData *> *result;
    RLMResults <HRRealmUser *> *userResult;
}
@property HRUserAFNetworkingModule *networkManager;
@property HRDataCenter *dataManager;
@property HRPostModel *postManager;
@property HRRealmUser *realmUser;
@property HRRealmData *realmData;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *count_post;
@property (weak, nonatomic) IBOutlet UILabel *date_firstPost;
@property (weak, nonatomic) IBOutlet UILabel *date_join;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *camThumbnail;

@end

@implementation HRUserViewController

RLMRealm  *realm;

- (void)viewDidAppear:(BOOL)animated {
    
    result = [HRRealmData allObjects];

    self.userLabel.text = [[NSString alloc] init];
    self.date_join.text = [[NSString alloc] init];
    self.date_firstPost.text = [[NSString alloc] init];
    [self setUserIDLabel];
    [self showSignDateLabel];
    [self showFirstPostLabel];
    [self showPostCountLabel];
    self.networkManager = [[HRUserAFNetworkingModule alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRealmProfileImage];
    [self setEntityStyle];
    
}

#pragma mark - layout arguments
-(void)setEntityStyle
{
    self.logOutBtn.layer.cornerRadius = self.logOutBtn.frame.size.height/2;     //로그아웃버튼 코너둥글기
    self.camThumbnail.layer.cornerRadius = self.camThumbnail.frame.size.height/2;       //프로파일사진 위 카메라섬네일 코너둥글기
    self.camThumbnail.clipsToBounds = YES;      //프로파일 사진 위 카메라섬네일 코너둥글기에 맞춰 테두리 자르기
}

#pragma mark - Calendar View
//FSCalendar 날짜 아래 점 표시
-(BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    self.postManager = [[HRPostModel alloc] init];
    
    NSString *start = [[self.postManager convertWithDate:date format:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00:00"];
    NSString *end   = [[self.postManager convertWithDate:date format:@"yyyy-MM-dd"] stringByAppendingString:@" 23:59:59"];
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate   = [dateFormatter dateFromString:end];
    
    RLMResults<HRRealmData *> *array = [result objectsWhere:@"date between {%@, %@}", startDate, endDate];
    NSLog(@"arraycount = %ld",[array count]);
    if([array count] > 0)
    {
        return YES;
    } else {
        return NO;
    }
}



#pragma mark - Profile Image Method
//프로필 이미지 클릭시 alert 띄워서 imagePicker 띄우는 메소드
- (IBAction)didClickedUserProfileImage:(UIButton *)sender
{   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *camAction = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *camController = [[UIImagePickerController alloc] init];
        camController.sourceType = UIImagePickerControllerSourceTypeCamera;
        camController.allowsEditing = YES;
//        camController.mediaTypes
//        = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        camController.delegate = self;
        
        [self presentViewController:camController animated: YES completion: nil];
    }];
    UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
        libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        libraryController.allowsEditing = YES;
        libraryController.delegate = self;
        
        [self presentViewController:libraryController animated:YES completion:nil];
    }];

    [alertController addAction:alertCancel];
    [alertController addAction:camAction];
    [alertController addAction:libAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.avatar setImage:image];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
    self.avatar.clipsToBounds = YES;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
    } else {
        NSLog(@"라이브러리 진입");
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
//        NSLog(@"imageData = %@",imageData);
    }
    
    //선택한 imageData를 파라메터로 받아 realmUser.userImage에 저장하는 메소드
    [self insertUserImageData:imageData];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

// realmUser타입 user객체를 realm에 추가
- (void)insertUserImageData:(NSData *)image
{
    //realm에 user객체추가
    [realm beginWriteTransaction];
    HRRealmUser *user = [[HRRealmUser alloc] init];
    user.userImage = image;
    user.userID = self.userLabel.text;
    [realm addObject:user];
    [realm commitWriteTransaction];
}

//HRUser 탭바가 선택될때 userImage를 불러오는 메소드
- (void)loadRealmProfileImage
{
    self.avatar.image = [[UIImage alloc] init];
    HRRealmUser *user = [[HRRealmUser alloc] init];
    user = [userResult lastObject];
    NSData *userImgData = user.userImage;
    NSLog(@"userImageData = %@", userImgData);
    if (userImgData != nil) {
        UIImage *userImg = [UIImage imageWithData:userImgData];
        [self.avatar setImage:userImg];
    } else {
        UIImage *defaultUserImg = [UIImage imageNamed:@"Avatar"];
        [self.avatar setImage:defaultUserImg];
    }
}

#pragma mark - Show Three Label Method
- (void)showPostCountLabel
{
//네트워크 이용
//    self.networkManager = [[HRUserAFNetworkingModule alloc]init];
//    __block NSString *countNum;
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
//    NSLog(@"token = %@",token);
//    [self.networkManager postListRequest:token completion:^(BOOL Sucess, NSDictionary *ResponseData) {
//        if (Sucess) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//                countNum = [NSString stringWithFormat:@"%@", [ResponseData objectForKey:@"count"]];
//                NSLog(@"countNum = %@",countNum);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (countNum != nil) {
//                        self.count_post.text = countNum;
//                        NSLog(@"countNumConfirm = %@",countNum);
//                    }
//                });
//            });
//        } else {
//            NSInteger responseStatusCode = ((NSHTTPURLResponse *)ResponseData).statusCode;
//            if (responseStatusCode == 401) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"토큰이 없거나 토큰값이 잘못됨/token: %@",ResponseData);
//                });
//            }
//        }
//    }];
//realm이용
//   
        RLMResults<HRRealmData *> *postday = [result objectsWhere:@"date != nil"];
        NSLog(@"realmDateCount = %ld",[postday count]);
        self.count_post.text = [NSString stringWithFormat:@"%ld",[postday count]];
        NSLog(@"realmDateCountToLabel = %@",self.count_post.text);
}

- (void)showFirstPostLabel
{
//네트워크 이용
//    self.networkManager = [[HRUserAFNetworkingModule alloc]init];
//    __block NSString *firstDate;
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
//    NSLog(@"token = %@",token);
//    [self.networkManager postListRequest:token completion:^(BOOL Sucess, NSDictionary *ResponseData) {
//        if (Sucess) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//                firstDate = (NSString *)[[[ResponseData objectForKey:@"results"] firstObject] objectForKey:@"day"];
//                NSLog(@"firstDate = %@",firstDate);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (firstDate != nil) {
//                        self.date_firstPost.text = firstDate;
//                        NSLog(@"firstDateConfirm = %@",firstDate);
//                    } else {
//                        self.date_firstPost.text = @"0";
//                    }
//                });
//            });
//        } else {
//            NSInteger responseStatusCode = ((NSHTTPURLResponse *)ResponseData).statusCode;
//            if (responseStatusCode == 401) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"토큰이 없거나 토큰값이 잘못됨/token: %@",ResponseData);
//                });
//            }
//        }
//    }];
    
//Realm 이용
    NSString *firstDate = [[NSString alloc] init];
    HRRealmData *firstObject = [result firstObject];
    //    [[HRRealmData allObjects] sortedResultsUsingKeyPath:@"date" ascending:YES];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    firstDate = [formatter stringFromDate:firstObject.date];
    
    self.date_firstPost.text = firstDate;
}

- (void)showSignDateLabel
{
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"signUpDate"];
    NSLog(@"signdate = %@", date);
    self.date_join.text = date;
    NSLog(@"signdateconfirm = %@", self.date_join.text);
}


#pragma mark - Logout Button methods
- (IBAction)didClickedLogoutBtn:(id)sender
{
    [self logoutSucess];
}


//로그아웃 후 alert
- (void)logoutSucess {
    
    NSString *tokenValue = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    NSLog(@"%@",tokenValue);
    
    [[HRDataCenter sharedInstance]logoutRequestToServer:^(BOOL isSuccess, id response) {
        if (isSuccess == YES) {
            NSLog(@"%@", response);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sucessLogoutAlert];
            });
        }
    }];
    
}

//로그아웃 성공 Alert
- (void)sucessLogoutAlert {
   
    UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"로그아웃" message:@"정상적으로 로그아웃 되었습니다" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tabBarController performSegueWithIdentifier:@"showTutorial" sender:nil];
    }];
    [logoutAlert addAction:okBtn];
    [self presentViewController:logoutAlert animated:YES completion:nil];
    [self.dataManager removeToken];
}


// 쓴글 표시를 위해 postlistRequest메소드 호출하여 count키값만 추출하여 count_post.text에 삽입


- (void)showPostCount
{
    //네트워크 이용
//    self.networkManager = [[HRUserAFNetworkingModule alloc]init];
//    __block NSString *result = [[NSString alloc] init];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
//    NSLog(@"token = %@",token);
//    [self.networkManager postListRequest:token completion:^(BOOL Sucess, NSDictionary *ResponseData) {
//        result = [ResponseData objectForKey:@"count"];
//    }];
//    NSLog(@"result = %@",result);
//    self.count_post.text = result;

    //realm이용
//    self.userLabel.text = [[NSString alloc] init];
//    self.postManager = [[HRPostModel alloc] init];
//    RLMResults<HRRealmData *> *postday = [self.result objectsWhere:@"date"];
//    NSLog(@"dateArray = %@",postday);
//    self.count_post.text = [NSString stringWithFormat:@"%ld",[postday count]];
    
//    RLMResults<HRRealmData *> *postday = [result objectsWhere:@"date != nil"];
//    NSLog(@"realmDateCount = %ld",[postday count]);
//    self.count_post.text = [NSString stringWithFormat:@"%ld",[postday count]];
//    NSLog(@"realmDateCountToLabel = %@",self.count_post.text);
    
    self.count_post.text = [NSString stringWithFormat:@"%ld", [result count]];
    NSLog(@"result count = %ld", [result count]);
}


- (void)setUserIDLabel
{
    self.networkManager = [[HRUserAFNetworkingModule alloc]init];
    [self.networkManager getUserProfile:^(BOOL Sucess, NSDictionary *ResponseData) {
        if (Sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.userLabel.text = [[[ResponseData objectForKey:@"results"] objectAtIndex:0] objectForKey:@"email"];
             });
        } else {
            NSInteger responseStatusCode = ((NSHTTPURLResponse *)ResponseData).statusCode;
            if (responseStatusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"토큰이 없거나 토큰값이 잘못됨/token: %@",ResponseData);
                });
            }
        }
    }];
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
