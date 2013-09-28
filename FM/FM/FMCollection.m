//
//  FMCollection.m
//  FM
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMCollection.h"
#import "FMCell.h"

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
    return 2;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0)
        return self.nameArray.count;
    if (section == 1)
        return self.dataArray.count;
    return 0;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    if (indexPath.section == 1)
        aCell.myLabel.text = self.dataArray[indexPath.row];
    else if (indexPath.section == 0)
        aCell.myLabel.text = self.nameArray[indexPath.row];
    return aCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.nameArray = @[@"Linus", @"Max", @"Jack", @"Leslie", @"Rolland"];
	self.dataArray = @[@"apple",@"pear",@"apple",@"pear",@"apple",@"pear",@"apple",@"pear",@"apple"];
    
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    CGFloat mainWidth = mainRect.size.width;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(mainWidth/self.nameArray.count, mainWidth/10);
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
