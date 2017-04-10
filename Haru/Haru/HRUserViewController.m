//
//  HRUserViewController.m
//  Haru
//
//  Created by SSangGA on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRUserViewController.h"
#import "HRUserAFNetworkingModule.h"


@interface HRUserViewController ()
<UITextFieldDelegate>
@property HRUserAFNetworkingModule *networkManager;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *count_post;
@property (weak, nonatomic) IBOutlet UILabel *count_streaks;
@property (weak, nonatomic) IBOutlet UILabel *date_join;

@end

@implementation HRUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didClickedLogoutBtn:(UIButton *)sender
{
//    [self.networkManager logoutRequest:^(BOOL Sucess, NSDictionary *ResponseData)
//    {
//        if (Sucess == YES) {
            UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"로그아웃" message:@"정상적으로 로그아웃 되었습니다" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Logout Alert");
                [logoutAlert addAction:okBtn];
                [self presentViewController:logoutAlert animated:YES completion:nil];
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
