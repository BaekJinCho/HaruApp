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


@interface HRUserViewController ()
<UITextFieldDelegate,FSCalendarDelegate,FSCalendarDataSource>
@property HRUserAFNetworkingModule *networkManager;
@property HRDataCenter *dataManager;
@property FSCalendar *calendrManager;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *count_post;
@property (weak, nonatomic) IBOutlet UILabel *count_streaks;
@property (weak, nonatomic) IBOutlet UILabel *date_join;

@end

@implementation HRUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPostCountToLabel];
}


//FSCalendar 날짜 아래 표시 글(subtitle)
-(NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSString *subtitle = @"P";
    return subtitle;
}

- (IBAction)didClickedLogoutBtn:(id)sender
{
    [self.dataManager logoutRequestToServer:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"로그아웃" message:@"정상적으로 로그아웃 되었습니다" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Logout Alert");
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"HRTutorial" bundle:nil];
                self.view.window.rootViewController = [mainStoryboard instantiateInitialViewController];
            }];
            [logoutAlert addAction:okBtn];
            [self presentViewController:logoutAlert animated:YES completion:nil];
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
