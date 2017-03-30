//
//  MainViewController.m
//  Haru
//
//  Created by 조백진 on 2017. 3. 29..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRMainViewController.h"

@interface HRMainViewController ()
<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//view가 화면에 보이지기 직전에 navigation 숨기기
#pragma mark- mainViewController viewWillAppear
- (void)viewWillAppear:(BOOL)Animated{
    [super viewWillAppear:Animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
//view가 화면에 사라지기 직전에 navigation 나타내기
#pragma mark- mainViewController viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//mainView의 row의 갯수를 생성하는 Method
#pragma mark- mainViewController numberOfRowsInSection Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
//mainView의 cell을 생성하는 Method
#pragma mark- mainViewController cellForRowAtIndexPath Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *mainViewCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (mainViewCell == nil) {
        mainViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return mainViewCell;
}
//mainView의 cell의 높이를 지정해주는 메소드
#pragma mark- mainViewController heightForRowAtIndexPath Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
//mainView의 cell을 클릭했을 때, 불리는 Method
#pragma mark- mainViewController didSelectRowAtIndexPath Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"DetailViewFromMainView" sender:nil];
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
