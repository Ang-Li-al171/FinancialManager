//
//  FMCollection.h
//  FM
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMCollection : UICollectionViewController

@property (strong, nonatomic) NSMutableArray *nameArray;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIImage * DEFAULT_TRANS_PIC;
@property (strong, nonatomic) UIImage * DINING;
@property (strong, nonatomic) UIImage * HOTEL;
@property (strong, nonatomic) UIImage * FUN;
@property (strong, nonatomic) UIImage * SHOPPING;

@property (strong, nonatomic) NSArray * PICArray;

@property NSInteger numItems;

@property (strong, nonatomic) NSMutableArray *transArray;

@property (strong, nonatomic) NSString *myNewTransName;

- (IBAction)createNewObj;

- (IBAction)setFlowAndItemSize;

@end
