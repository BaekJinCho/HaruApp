//
//  HRCollectionViewController.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRCollectionViewCell.h"
#import "AddViewController.h"
#import "HRRealmData.h"
#import "HRPostModel.h"

@interface HRCollectionViewController : UIViewController
{
    RLMResults *collectionDataArray;
}



@end
