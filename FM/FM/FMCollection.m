//
//  FMCollection.m
//  FM
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMCollection.h"
#import "FMCell.h"
#import "IconButton.h"

@interface FMCollection ()

@end

@implementation FMCollection

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView{
    return self.nameArray.count+1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numItems+1;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IconButton* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myButton" forIndexPath:indexPath];
        aCell.myButton.titleLabel.text = self.transArray[indexPath.row];
        return aCell;
    }
    else{
        FMCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        if (indexPath.row == 0)
            aCell.myLabel.text = self.nameArray[indexPath.section - 1 ];
        else if (indexPath.row < self.numItems)
            aCell.myLabel.text = self.dataArray[(indexPath.row-1) * self.nameArray.count + (indexPath.section-1)];
        else
            aCell.myLabel.text  = @"SUM";
        return aCell;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameArray = [[NSMutableArray alloc] init];
    [self.nameArray insertObject:@"Linus" atIndex:0];
    [self.nameArray insertObject:@"Max" atIndex:0];
    [self.nameArray insertObject:@"Jack" atIndex:0];
    [self.nameArray insertObject:@"Leslie" atIndex:0];
    [self.nameArray insertObject:@"Rolland" atIndex:0];
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray insertObject:@"100/-20" atIndex:0];
    [self.dataArray insertObject:@"1/-20" atIndex:0];
    [self.dataArray insertObject:@"0/-20" atIndex:0];
    [self.dataArray insertObject:@"-1/-20" atIndex:0];
    [self.dataArray insertObject:@"0/-20" atIndex:0];
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    [self.dataArray insertObject:@"100/0" atIndex:0];
    [self.dataArray insertObject:@"100/-200" atIndex:0];
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    self.transArray = [[NSMutableArray alloc] init];
    [self.transArray insertObject:@"Total" atIndex:0];
    [self.transArray insertObject:@"Trans2" atIndex:0];
    [self.transArray insertObject:@"Trans1" atIndex:0];
    [self.transArray insertObject:@"Empty" atIndex:0];
    self.numItems = self.transArray.count-1;
    
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    CGFloat mainWidth = mainRect.size.width;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 5, 0, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake((mainWidth-10*(self.nameArray.count+1))/(self.nameArray.count+1), mainWidth/15);
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createNewObj
{
    NSLog(@"Did go to createNewObj");
    [self.transArray insertObject:self.myNewTransName atIndex:0];
    
    [self.collectionView reloadData];
    
}

@end
