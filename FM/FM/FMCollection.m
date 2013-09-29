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
#import "CollectionFlowLayout.h"

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

//define size for each cell
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        return CGSizeMake(60, 60);
    }
    else{
        CGRect mainRect = [[UIScreen mainScreen] bounds];
        CGFloat mainWidth = mainRect.size.width;
        return CGSizeMake(((mainWidth-10*(self.nameArray.count+1))-80)/(self.nameArray.count), 60);
    }
}

//returns the number of sections
-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView{
    return self.nameArray.count+1;
}

//return the num of items in each section
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numItems+1;
}

//return cell for each specific index path
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IconButton* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myButton" forIndexPath:indexPath];
        aCell.myButton.titleLabel.text = self.transArray[indexPath.row];
        [aCell.myButton setImage:self.PICArray[indexPath.row] forState:UIControlStateNormal];
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

- (void)setFlowAndItemSize{

    UICollectionViewFlowLayout *flowLayout = [[CollectionFlowLayout alloc] init];
    
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.DEFAULT_TRANS_PIC = [UIImage imageNamed:@"transaction_6060.png"];
    self.DINING = [UIImage imageNamed:@"restaurant_icon_6060.png"];
    self.HOTEL = [UIImage imageNamed:@"Hotel Icon black_6060.png"];
    self.FUN = [UIImage imageNamed:@"icon-attraction_6060.png"];
    self.SHOPPING = [UIImage imageNamed:@"shopping_cart_icon_6060.jpg"];
    
    self.PICArray = @[self.DEFAULT_TRANS_PIC, self.DINING, self.HOTEL, self.FUN, self.SHOPPING];
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
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    [self.dataArray insertObject:@"100/0" atIndex:0];
    [self.dataArray insertObject:@"100/-200" atIndex:0];
    [self.dataArray insertObject:@"100/-100" atIndex:0];
    self.transArray = [[NSMutableArray alloc] init];
    [self.transArray insertObject:@"Total" atIndex:0];
    [self.transArray insertObject:@"Trans3" atIndex:0];
    [self.transArray insertObject:@"Trans2" atIndex:0];
    [self.transArray insertObject:@"Trans1" atIndex:0];
    [self.transArray insertObject:@"Empty" atIndex:0];
    self.numItems = self.transArray.count-1;
    
    
    [self setFlowAndItemSize];
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
