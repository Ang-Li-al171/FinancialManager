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
#import "FMTrip.h"
#import "TransController.h"

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

- (void)initWithTripPtr:(FMTrip *)tripPtr{
    self.myTrip = tripPtr;
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
        return CGSizeMake(((mainWidth-10*(self.myTrip.peoples.count+1))-80)/(self.myTrip.peoples.count), 60);
    }
}

//returns the number of sections
-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView{
    return self.myTrip.peoples.count+1;
}

//return the num of items in each section
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numItems+1;
}

//return cell for each specific index path
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IconButton* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myButton" forIndexPath:indexPath];
        
        int picNum = 3; //default is 3
        
        if (indexPath.row < self.numItems && indexPath.row > 0)
            picNum = [self switchCate:[[self.myTrip getEventArray] objectAtIndex:indexPath.row-1]];
        [aCell.myButton setImage:self.PICArray[picNum] forState:UIControlStateNormal];
        return aCell;
    }
    else{
        FMCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        aCell.myLabel.text = [[[self.myTrip getNameEntrys] objectAtIndex: (indexPath.section-1)] objectAtIndex: indexPath.row];
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
    
    self.PICArray = @[self.DINING, self.HOTEL, self.FUN, self.DEFAULT_TRANS_PIC, self.SHOPPING];

    NSLog(@"%d size of entryarray", [self.myTrip getEventArray].count);
    self.numItems = [self.myTrip getEventArray].count;
    
    [self setFlowAndItemSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refresh
{
    self.numItems = [self.myTrip getEventArray].count;
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"addTrans"])
    {
        // Get reference to the destination view controller
        TransController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setPeopleList:self.myTrip.peoples];
    }
}

- (int) switchCate: (NSString*) str {
    int pic = 0;
    if ([str isEqualToString:@"Dining"])
        pic = 0;
    else if ([str isEqualToString:@"Hotel"])
        pic = 1;
    else if ([str isEqualToString:@"Fun Park"])
        pic = 2;
    else if ([str isEqualToString:@"Payment"])
        pic = 3;
    else if ([str isEqualToString:@"Shopping"])
        pic = 4;
    return pic;
}

@end
