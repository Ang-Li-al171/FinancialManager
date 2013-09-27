//
//  ObjToEncode.h
//  FinancialManager
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013  mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjToEncode : NSObject

@property NSString *name;
@property int age;
- (id) initWithName: (NSString*) n Age: (int) a;
- (id) initWithCoder: (NSCoder *) coder;
@end
