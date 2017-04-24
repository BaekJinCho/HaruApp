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
@property (nonatomic) NSFileManager *fileManager;

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
//        self.haruDataArray      = [[NSArray alloc] init];
        
        //haruData 저장하는 mutableArrays init
        self.inHaruContentArray = [[NSMutableArray alloc] init];
        
        self.fileManager = [[NSFileManager alloc] init];

        
/************************************plist로 작업시********************************************/
        //plist에 있는 것 set
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *basePath = [paths objectAtIndex:0];
//        NSString *docuPath = [basePath stringByAppendingPathComponent:@"harData.plist"];
//        
//        
//        NSArray *dataArrays;
//        
//        if ([self.fileManager fileExistsAtPath:docuPath]) {
//            dataArrays = [NSArray arrayWithContentsOfFile:docuPath];
//        
//        } else {
//            
//            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"harData" ofType:@"plist"];
//            //데이터 array에 bundle 내용 넣음
//            dataArrays = [NSArray arrayWithContentsOfFile:bundlePath];
//        }
//        
//        for (NSDictionary *haruItem in dataArrays) {
//            HRPostModel *haruDataModel = [[HRPostModel alloc] initWithDictionary:haruItem];
//            [self.inHaruContentArray addObject:haruDataModel];
//        }
/************************************plist로 작업시********************************************/
    
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
                                       NSLog(@"성공일 때, response : %@",response);
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
                                            NSLog(@"성공 response : %@",response);
                    
                                            NSString *token = [(NSDictionary *)response objectForKey:ACCOUNT_KEY_OF_SERVER];
                                            [self saveToken:token];
                                        }
                                        completion(isSuccess, response);
    }];
}

//로그아웃 Method
- (void)logoutRequestToServer:(BlockOnCompletion)completion {
    
    [self.networkManager logoutRequestToServer:^(BOOL isSuccess, id response) {
        if (isSuccess == YES) {
            [self removeToken];
            
        }

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
    self.userToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY_OF_USERDEFAULTS];
}


//Post 관련 Method

//plist에서 불러오기
//- (void)loadData {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *basePath = [paths objectAtIndex:0];
//    NSString *docuPath = [basePath stringByAppendingPathComponent:@"harData.plist"];
//    
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//    if (![fileManger fileExistsAtPath:docuPath]) {
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"harData" ofType:@"plist"];
//        [fileManger copyItemAtPath:bundlePath toPath:docuPath error:nil];
//    }
//    self.inHaruContentArray = [[NSArray arrayWithContentsOfFile:docuPath] mutableCopy];
//}
//
////plist에 저장
//- (void)saveData {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *basePath = [paths objectAtIndex:0];
//    NSString *docuPath = [basePath stringByAppendingPathComponent:@"harData.plist"];
//    
//    
//    if (![self.fileManager fileExistsAtPath:docuPath]) {
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"harData" ofType:@"plist"];
//        [self.fileManager copyItemAtPath:bundlePath toPath:docuPath error:nil];
//    }
//    [self.inHaruContentArray writeToFile:docuPath atomically:NO];
//}

- (void)mainViewList:(BlockOnCompletion)completion {
    
    [self readDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
        
        if (isSuccess) {
            
            NSDictionary *haruDataTemp = (NSDictionary *)response;
            
            NSArray *haruDataArrayToDictionaryTemp = [haruDataTemp objectForKey:@"diaryResult"];
            
            
            for (NSDictionary *resultData in haruDataArrayToDictionaryTemp) {
                HRPostModel *haruDataTemp = [[HRPostModel alloc] initWithDictionary:resultData];
                
//                self.haruDataArray = [resultData allKeys];
//                self.inHaruContentArray = [self.haruDataArray mutableCopy];
                [self.inHaruContentArray addObject:haruDataTemp];
//                self.haruDataArray = self.inHaruContentArray;
            }
            completion(isSuccess, response);
            
        } else {
            
            completion(isSuccess, nil);
        }
        
//        if (isSuccess) {
//            
//            NSDictionary *haruDataTemp = (NSDictionary *)response;
//            NSArray *haruDataArrayToDictionaryTemp2 = [haruDataTemp objectForKey:@"diaryResult2"];
//            for (NSDictionary *resultData in haruDataArrayToDictionaryTemp2) {
//                HRPostModel *haruDataTemp = [[HRPostModel alloc] initWithDictionary:resultData];
//                
//                [self.inHaruContentArray addObject:haruDataTemp];
//            }
//            completion(isSuccess, response);
//            
//        } else {
//            
//            completion(isSuccess, nil);
//        }
   
        
    }];
}




//일기의 관한 데이터들을 indexpath.row로 받게하는 Method
- (HRPostModel *)contentDataAtIndexPath:(NSIndexPath *)haruContentDataAtIndexPath {
    
    return self.inHaruContentArray[haruContentDataAtIndexPath.row];
}

//일기(일기의 Content)를 추가하는 Method
- (void)insertDiaryContent:(HRPostModel *)haruContentData {
    
//    self.inHaruContentArray = [self.haruDataArray mutableCopy];
    [self.inHaruContentArray insertObject:haruContentData atIndex:0];

//    self.haruDataArray = self.inHaruContentArray;
    
}

//일기(일기의 Content)를 삭제하는 Method
- (void)deleteDiaryContent:(NSIndexPath *)haruContentsDataAtIndexPath {
    
//    self.inHaruContentArray = [self.haruDataArray mutableCopy];
    [self.inHaruContentArray removeObjectAtIndex:haruContentsDataAtIndexPath.row];

//    self.haruDataArray = self.inHaruContentArray;

}

//일기(일기의 Content)를 수정하는 Method
- (void)updateDiaryContent:(NSIndexPath *)haruContentsAtIndexPath haruContentsData:(HRPostModel *)haruContentsData {
//    self.inHaruContentArray = [self.haruDataArray mutableCopy];
    [self.inHaruContentArray replaceObjectAtIndex:haruContentsAtIndexPath.row withObject:haruContentsData];
//    self.haruDataArray = self.inHaruContentArray;
}

//tableview의 numberOfRowsInSection에 들어갈 수
- (NSUInteger)numberOfItem {
    
    return self.inHaruContentArray.count;
    
}



//json 파일 읽는 Method
- (void)readDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
    
    NSData *partyData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //convert JSON NSData to a usable NSDictionary
    NSError *error;
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:partyData
                                                                 options:0
                                                                   error:&error];
    
    completionHandler(YES, responseData);
}



////json 파일 쓰는 Method
//- (void)writeDictionaryFromWithFilepath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
//    
//    for (HRPostModel *diary in self.haruDataArray) {
//        
//        NSDictionary *dic = @{@"Date":diary.totalDate, @"Title":diary.title
//                              , @"Content":diary.content, @"Image":@"http://www.city.kr/files/attach/images/1326/542/186/010/9bbd68054422876eb730b296963d0e82.jpg"
//                              };
//        
//        [self.inHaruContentArray addObject:dic];
//    }
//    
//    NSDictionary *temp = @{
//                           @"count":@"1",
//                           @"results":self.inHaruContentArray
//                           };
//    
//    NSData *data       = [NSJSONSerialization dataWithJSONObject:temp options:kNilOptions error:nil];
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
//    
//    [data writeToFile:filePath atomically:YES];
//    
//    completionHandler(YES, nil);
//}
//
//#pragma mark- Diary Add Method
////다이어리 추가했을 때 Method
//- (void)insertDictionaryFromFilePath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
//    
//    
//    [self writeDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
//        
//        [self readDictionaryFromWithFilepath:@"inHarun" completionHanlder:^(BOOL isSuccess, id response) {
//            
//            completionHandler(YES, response);
//        }];
//        
//    }];
//    
//}
//
//#pragma mark- Diary Update Method
////json 파일 수정 Method
//- (void)updateDictionaryFromFilePath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
//    
//    [self writeDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
//        
//        [self readDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
//            
//            completionHandler(YES, response);
//        
//        }];
//        
//    }];
//    
//    
//    
//}
//
//
//#pragma mark- Diary Delete Method
////json 파일 삭제 Method
//- (void)deleteDictionaryFromFilePath:(NSString *)filePathString completionHanlder:(BlockOnCompletion)completionHandler {
//    
//    [self writeDictionaryFromWithFilepath:@"inHaru" completionHanlder:^(BOOL isSuccess, id response) {
//        
//        [self readDictionaryFromWithFilepath:@"inHarun" completionHanlder:^(BOOL isSuccess, id response) {
//            
//            completionHandler(YES, response);
//        }];
//        
//    }];
//    
//    
//}



@end
