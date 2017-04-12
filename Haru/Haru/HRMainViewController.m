//
//  MainViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRMainViewController.h"
#import "HRCustomTableViewCell.h"
#import "HRDetailViewController.h"

@interface HRMainViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation HRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //기존의 로그인이 되어있는지 확인 후 로그인이 되어 있다면 메인페이지 보여주기 / 로그인 기록이 없다면 Tutorial 페이지 보여주기 로직 처리
    
    //custom cell nib 파일 가져오기
    UINib *nib = [UINib nibWithNibName:@"HRCustomTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nib forCellReuseIdentifier:@"HRCustomTableViewCell"];
    
    [[HRDataCenter sharedInstance] testList:^(BOOL isSuccess, id response) {
        NSLog(@"response %@", response);
        if(isSuccess) {
            
            [self.mainTableView reloadData];
        }
    }];
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


//mainView의 row의 갯수를 생성하는 Method
#pragma mark- mainViewController numberOfRowsInSection Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Section에 들어가는 Row의 수 : %ld", section);
    return [[HRDataCenter sharedInstance] numberOfItem];
}

//mainView의 cell을 생성하는 Method
#pragma mark- mainViewController cellForRowAtIndexPath Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //storyboard를 사용할 떈, forIndexPath를 사용!!!
    HRCustomTableViewCell *mainViewCell = [tableView dequeueReusableCellWithIdentifier:@"HRCustomTableViewCell"
                                                                          forIndexPath:indexPath];
    
    HRPostModel *haruData = [[HRDataCenter sharedInstance] contentDataAtIndexPath:indexPath];
    
    mainViewCell.postTitle.text = haruData.title;
    mainViewCell.mainTableViewCellYearMonthLabel.text = haruData.dateFormatYearMonth;
    mainViewCell.dateLabel.text = haruData.dateFormatDay;
    mainViewCell.dayOfTheWeekLabel.text = haruData.dateFormatDayOfTheWeek;
    [mainViewCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:haruData.image]                        placeholderImage:[UIImage imageNamed:@"Background4"]];
    
    
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
    HRDetailViewController *detailViewContent = [HRDetailViewController new];
//    if([segue.identifier isEqualToString:@"DetailViewFromMainView"]) {
//        
        HRDetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.indexPath = (NSIndexPath *)sender;
//        
//        //HRPostModel *mainViewData = //네트워크 데이터 넣어주기
//        
//        [detailViewContent.detailViewBackgroundPhoto sd_setImageWithURL:[NSURL URLWithString:haruData.image]                        placeholderImage:[UIImage imageNamed:@"Background4"]];
//        detailViewContent.detailViewPostTitle.text = haruData.title;
//        detailViewContent.detailViewContentLabel.text = haruData.content;
    
    
       
//    }
}

//tableview를 edit 할 수 있게 해주는 Method
#pragma mark- mainVeiwController canEditRowAtIndexPath Method
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

//tableview를 edit style를 정해주는 Method
#pragma mark- mainVeiwController commitEditing Method
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.cellData removeObjectAtIndex:indexPath.row];
//        NSMutableArray *arrayForRemove = [self.dataArray mutableCopy];
//        [arrayForRemove removeObjectAtIndex:indexPath.row];
//        self.dataArray = [NSArray arrayWithArray:arrayForRemove];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }

}




#pragma mark- mainViewController unwindSegut Method
- (IBAction)unwindMainViewSegue:(UIStoryboardSegue *)sender {
    
    //변경된 데이터 조회
    
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
