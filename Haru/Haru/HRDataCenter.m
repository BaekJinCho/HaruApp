//
//  HRDataCenter.m
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 27..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import "HRDataCenter.h"

@interface HRDataCenter ()

@property (nonatomic) HRNetworkModule *networkManager;
@property (nonatomic) NSArray * haruDataArray; //일기의 데이터들이 들어가는 Array
@property (nonatomic) NSMutableArray * inHaruContentArray;
@end

@implementation HRDataCenter


//싱글턴
+ (instancetype) sharedInstance {
    
    static HRDataCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[HRDataCenter alloc] init];
    });
    return center;
}


//초기화 메소드
- (instancetype) init {
    self = [super init];
    if (self) {
        self.networkManager     = [[HRNetworkModule alloc] init];
        
        self.haruDataArray      = [[NSArray alloc] init];
        self.inHaruContentArray = [[NSMutableArray alloc] init];

    
    }
    return self;
}

//유저의 token 값 저장
- (NSString *)getUserToken
{
    if (self.userToken == nil) {
        self.userToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    }
    return self.userToken;
}

//자동 로그인 체크하는 Method
- (BOOL)isAutoLogin {
    
    NSString *loginNewToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_KEY_OF_USERDEFAULTS];
    if (loginNewToken != nil) {
        self.userToken = loginNewToken;
        return YES;
    }
    return NO;
    
}

//로그인 Method
- (void)loginRequestWithUserID:(NSString *)userID
                      password:(NSString *)password
                    completion:(BlockOnCompletion)completion {
    
    [self.networkManager loginRequestToServer:userID
                                     password:password
                                   completion:^(BOOL isSuccess, id response) {
                                       if (isSuccess == YES) {
                                           NSString *token = [(NSDictionary *)response objectForKey:ACCOUNT_KEY_OF_SERVER];
                                           [self saveToken:token];
                                       }
                                       completion(isSuccess, response);
                                   }];
}

//회원가입 Method
- (void)joinRequestWithUserID:(NSString *)userID
                        password:(NSString *)password
                       password2:(NSString *)password2
                     completion:(BlockOnCompletion)completion {
    
    [self.networkManager joinRequestToServer:userID
                                      password:password
                                     password2:password2
                                    completion:^(BOOL isSuccess, id response) {
                                        
                                        if (isSuccess == YES) {
                    
                                            NSString *token = [(NSDictionary *)response objectForKey:ACCOUNT_KEY_OF_SERVER];
                                            [self saveToken:token];
                                        }
                                        completion(isSuccess, response);
    }];
}

//로그아웃 Method
- (void)logoutRequestToServer:(BlockOnCompletion)completion {
    
    [self.networkManager logoutRequestToServer:^(BOOL isSuccess, id response) {
        [self removeToken];
        completion (isSuccess, response);
        
    }];
    
}

// HR main list
- (void)testList:(BlockOnCompletion)completion {
    
    [self readDictionaryFromWithFilepath:@"inHaru" andHandler:^(BOOL isSuccess, id response) {
        
        completion(isSuccess, response);
    }];
}

#pragma mark - Private Method
//token 저장 Method
- (void)saveToken:(NSString *)token {
    
    self.userToken = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN_KEY_OF_USERDEFAULTS];
}

//token 제거 Method
- (void)removeToken {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY_OF_USERDEFAULTS];
}


//Post 관련 Method
- (HRPostModel *)diaryDataAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.haruDataArray[indexPath.row];
}

#pragma mark- Diary Add Method
//다이어리 추가했을 때 Method
- (void)addDiaryContentData:(HRPostModel *)postContent completion:(BlockOnCompletion)completion {
    
    self.inHaruContentArray = [self.haruDataArray mutableCopy];
    
    [self.inHaruContentArray addObject:postContent];
    
    self.haruDataArray = self.inHaruContentArray;
    
    completion(YES, postContent);
    
    
}

#pragma mark- Diary Remove Method
//다이어리 제거했을 때 Method
- (void)removeDiaryContentData:(HRPostModel *)postContent completion:(BlockOnCompletion)completion {
    
    self.inHaruContentArray = [self.haruDataArray mutableCopy];
    
    [self.inHaruContentArray removeObject:postContent];
    
    self.haruDataArray = self.inHaruContentArray;
    
    completion(YES, postContent);
    
}

//json 파일 읽는 Method
- (void)readDictionaryFromWithFilepath:(NSString *)filePathString andHandler:(BlockOnCompletion)completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
    
    NSData *partyData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //convert JSON NSData to a usable NSDictionary
    NSError *error;
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:partyData
                                                                 options:0
                                                                   error:&error];
    
    completionHandler(YES, responseData);
}

//json 파일 쓰는 Method
- (void)writeDictionaryFromWithFilepath:(NSString *)filePathString andHandler:(BlockOnCompletion)completionHandler {
    
    for (HRPostModel *diary in self.haruDataArray) {
        
        NSDictionary *dic = @{@"Date":diary.date, @"Title":diary.title
                              , @"Content":diary.content, @"Image":@"http://www.city.kr/files/attach/images/1326/542/186/010/9bbd68054422876eb730b296963d0e82.jpg"
                              };
        
        [self.inHaruContentArray addObject:dic];
    }
    
    NSDictionary *temp = @{
                           @"count":@"1",
                           @"results":self.inHaruContentArray
                           };
    
    NSData *data       = [NSJSONSerialization dataWithJSONObject:temp options:kNilOptions error:nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
    
    [data writeToFile:filePath atomically:YES];
    
    completionHandler(YES, nil);
}





//- (void)requestInDiaryListWithCompletionHandler:(BlockOnCompletion)completionHandler {
//    
//    [self readDictionaryFromWithFilepath:@"inDiary" andHandler:^(BOOL isSuccess, id responseData) {
//        
//        if(isSuccess) {
//            
//            NSDictionary *resultInfo = (NSDictionary *)responseData;
//            
//            NSDictionary *inDiaryInfo   = [resultInfo objectForKey:@"diaryResult"];
//            NSArray      *inDiaryArray  = [resultInfo objectForKey:@"inDiaryResults"];
//            
//            self.inDiaryInfo      = [inDiaryInfo mutableCopy];
//            
//            for (NSDictionary *diaryInfo in inDiaryArray) {
//                
//                HRPostModel *data = [[HRPostModel alloc] initWithDictionary:inDiaryInfo];
//                [self.inDiaryDataArray addObject:data];
//            }
//            
//            completionHandler(isSuccess, responseData);
//        } else {
//            
//            completionHandler(isSuccess, nil);
//        }
//        
//    }];
//}




@end
