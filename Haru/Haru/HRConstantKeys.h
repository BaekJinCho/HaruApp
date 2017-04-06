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
static NSString * const BASE_URL = @"";
//static NSString * const LOGIN_URL = @"";
static NSString * const JOIN_URL = @"";



//Data Modeling에 필요한 것
static NSString * const DATE_KEY = @"date";
static NSString * const TITLE_KEY = @"Title";
static NSString * const CONTENT_KEY = @"content";
static NSString * const IMAGE_KEY = @"image";
static NSString * const USERSTATE_KEY = @"userState";


//추가 화면 및 수정 화면에서 title & content 글자 수 제한에 필요한 것
static NSUInteger MAX_POST_TITLE_CONTENT = 13; //일기 제목의 글자 제한 주기위한 변수
static NSUInteger MAX_POST_CONTENT = 110; //일기 내용의 글자 제한 주기위한 변수


#endif /* HRConstantKeys_h */
