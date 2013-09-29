//
//  menuButton.m
//  FM
//
//  Created by Ang Li on 9/29/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "menuButton.h"

@implementation menuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setRowNum: (int) num{
    self.myRowNum = num;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
