//
//  HRConstantKeys.h
//  Haru
//
//  Created by 조백진 on 2017. 4. 6..
//  Copyright © 2017년 jcy. All rights reserved.
//

#ifndef HRConstantKeys_h
#define HRConstantKeys_h

//API 주소
static NSString * const BASIC_URL = @"https://fc-ios.lhy.kr/api";
static NSString * const JOIN_URL = @"/member/signup/";
static NSString * const LOGIN_URL = @"/member/login/";
static NSString * const LOGOUT_URL = @"/member/logout/";
static NSString * const POST_URL = @"/post/";

//Method 방식
static NSString * const POST_METHOD = @"POST";
static NSString * const GET_METHOD = @"GET";

//Token KEY
static NSString * const TOKEN_KEY = @"Authorization";
// 서버에서 받은 키 값
static NSString * const ACCOUNT_KEY_OF_SERVER = @"key";
// 서버에서 받은 키값을 토큰으로 저장
static NSString * const TOKEN_KEY_OF_USERDEFAULTS = @"Token";

//API STATUSCODE
static NSInteger const STATUSCODE_LOGIN_SUCCESS = 200;
static NSInteger const STATUSCODE_JOIN_SUCCESS = 201;
static NSInteger const STATUSCODE_LOGOUT_SUCCESS = 200;


//Data Modeling에 필요한 것
static NSString * const DATE_KEY = @"Date";
static NSString * const TITLE_KEY = @"Title";
static NSString * const CONTENT_KEY = @"Content";
static NSString * const IMAGE_KEY = @"Photo";
static NSString * const USERSTATE_KEY = @"State";

////유저 감정상태 정의
//typedef NS_ENUM(NSUInteger, HRUserEmotionalState) {
//    HRUserEmotionalStateAngry,
//    HRUserEmotionalStateHappy,
//    HRUserEmotionalStateSad,
//    HRUserEmotionalStateSoso,
//    HRUserEmotionalStateUpset
//};


//추가 화면 및 수정 화면에서 title & content 글자 수 제한에 필요한 것
static NSUInteger MAX_POST_TITLE_CONTENT = 13; //일기 제목의 글자 제한 주기위한 변수
static NSUInteger MAX_POST_CONTENT = 110; //일기 내용의 글자 제한 주기위한 변수


#endif /* HRConstantKeys_h */
