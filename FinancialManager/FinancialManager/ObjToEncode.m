//
//  ObjToEncode.m
//  FinancialManager
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013  mac. All rights reserved.
//

#import "ObjToEncode.h"

@implementation ObjToEncode

@synthesize name, age;

-(void) endcodeWithCoder: (NSCoder *) coder{
    [coder encodeObject:name forKey:@"Name"];
    [coder encodeInt:age forKey:@"Age"];
}

- (id) initWithCoder: (NSCoder *) coder{
    self = [super init];
    name = [coder decodeObjectForKey:@"Name"];
    age = [coder decodeIntegerForKey:@"Age"];
    return self;
}

- (id) initWithName: (NSString*) n Age: (int) a{
    self = [super init];
    name = n;
    age = a;
    return self;
}


@end
