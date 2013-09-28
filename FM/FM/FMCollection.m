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
    
    self.nameArray = @[@"Linus", @"Max", @"Jack", @"Leslie", @"Rolland"];
	self.dataArray = @[@"100/20",@"100/20",@" ",@"100/20",@"0/0",@"100/20",@"100/20",@" ",@"0/20"
                    ,@"0/20",@"0/20",@"0/20",@"0/20",@"0/0", @"0/0"];
    self.transArray = @[@" ", @"Trans1", @"Trans2", @"Trans3", @"Total"];
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

@end
