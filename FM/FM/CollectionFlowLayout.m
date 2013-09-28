//
//  CollectionFlowLayout.m
//  FM
//
//  Created by Ang Li on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "CollectionFlowLayout.h"

@implementation CollectionFlowLayout

- (id)init
{
    self.sectionInset = UIEdgeInsetsMake(30, 5, 0, 5);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    return self;
}

@end
