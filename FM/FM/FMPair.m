//
//  FMPair.m
//  FM
//
//  Created by  mac on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMPair.h"

#import "FMPair.h"

@implementation FMPair

@synthesize paid,shouldPay;

-(id) init{
    self = [super init];
    paid = 0;
    shouldPay = 0;
    return self;
}

-(void) encodeWithCoder: (NSCoder*) coder {
    [coder encodeObject:[NSNumber numberWithInt:paid ] forKey:@"Paid"];
    [coder encodeObject:[NSNumber numberWithInt:shouldPay] forKey:@"ShouldPay"];
}

-(id) initWithCoder:(NSCoder*) coder{
    self = [super init];
    paid = (int)[[coder decodeObjectForKey:@"Paid"] integerValue];
    shouldPay = (int)[[coder decodeObjectForKey:@"ShouldPay"] integerValue];
    return self;
}

@end
