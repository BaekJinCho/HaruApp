//
//  MainViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRMainViewController.h"
#import "HRCustomTableViewCell.h"
#import "HRPostModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "HRDetailViewController.h"

@interface HRMainViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation HRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //custom cell nib 파일 가져오기
    UINib *nib = [UINib nibWithNibName:@"HRCustomTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nib forCellReuseIdentifier:@"HRCustomTableViewCell"];
    
}

//alert 알람 띄우기 클래스 메소드
+ (UIAlertController *)modalWithTitle:(NSString *)title andContent:(NSString *)content andHandler:(void (^)(void))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actions = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:actions];
    return alert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- mainViewController numberOfSection Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

//mainView의 row의 갯수를 생성하는 Method
#pragma mark- mainViewController numberOfRowsInSection Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"numberOfRowsInSection");
    return 2;
}

//mainView의 cell을 생성하는 Method
#pragma mark- mainViewController cellForRowAtIndexPath Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //storyboard를 사용할 떈, forIndexPath를 사용!!!
    HRCustomTableViewCell *mainViewCell = [tableView dequeueReusableCellWithIdentifier:@"HRCustomTableViewCell"
                                                                          forIndexPath:indexPath];
    
    //arc4random()는 자동으로 초기화 작업을 하여 별도의 초기화 하는 불필요한 작업이 필요없다.
    //default를 랜덤하게 넣어주기 위한 작업
//    int x = arc4random() % 10;
//    NSString *randomImageName = [NSString stringWithFormat:@"HRMainViewRandomImage%d",x];
//    UIImage *randomImage      = [UIImage imageNamed:randomImageName];
//    
//    //기본 이미지를 넣어주는 것!
//    [mainViewCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:@"이미지 URL"]                        placeholderImage:randomImage];

    return mainViewCell;
}

//mainView header Section Method
#pragma mark- mainViewController titleForHeaderInSection Method
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    NSString *headerTitle = [NSString stringWithFormat:@"2017년 %ld월", section];
//    return headerTitle;
//}

////mainView header Section Custom 하기 위한 Method
//#pragma mark- mainViewController viewForHeaderInSection Method
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *mainHeaderTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
//    UILabel *mainHeaderTitleLabel = [[UILabel alloc] initWithFrame:mainHeaderTitleView.bounds];
//    NSString *headerTitle = [NSString stringWithFormat:@"2017년 %ld월", section];
//    
//    mainHeaderTitleLabel.text= headerTitle;
//    [mainHeaderTitleLabel setFont:[UIFont fontWithName:@"Apple SD Gothic Neo" size:17]];
//    mainHeaderTitleLabel.textColor = [UIColor colorWithWhite:255/255.0 alpha:0.8];
//    mainHeaderTitleLabel.textAlignment = NSTextAlignmentCenter;
//    [mainHeaderTitleView addSubview:mainHeaderTitleLabel];
//    return mainHeaderTitleView;
//}

////heightForHeader Method (header를 custom 하게 만들고 header의 높이를 꼭 줘야한다. View의 height와 같은 값을 줘야 header의 가운데의 온다.)
//#pragma mark- mainViewController heightForHeaderInSection Method
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}

//mainView의 cell의 높이를 지정해주는 메소드
#pragma mark- mainViewController heightForRowAtIndexPath Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size.width;
}

//mainView의 cell을 클릭했을 때, 불리는 Method
#pragma mark- mainViewController didSelectRowAtIndexPath Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"DetailViewFromMainView" sender:indexPath];
}

#pragma mark- mainViewController PrepareForSegue Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    HRDetailViewController *detailViewController = 
    if([segue.identifier isEqualToString:@"DetailViewFromMainView"]) {
        
        //HRPostModel *mainViewData = //네트워크 데이터 넣어주기
        
        HRDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.indexPath = (NSIndexPath *)sender;
        
    }
}

- (IBAction)unwindMainViewSegue:(UIStoryboardSegue *)sender {
    
    
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
