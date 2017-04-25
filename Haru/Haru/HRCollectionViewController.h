//
//  HRCollectionViewController.h
//  Haru
//
//  Created by Won Suk Choi on 2017. 3. 30..
//  Copyright © 2017년 jcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRCollectionViewCell.h"
#import "HRAddViewController.h"
#import "HRRealmData.h"
#import "HRPostModel.h"
#import "HRDetailViewController.h"

@interface HRCollectionViewController : UIViewController
{
    RLMResults *collectionDataArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
