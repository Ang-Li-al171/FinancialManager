//
//  FMTrip.h
//  FM
//
//  Created by  mac on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMTrip.h"
#import "FMPair.h"

@interface Trip : NSObject

@property NSString * description;
@property NSMutableArray *peoples;
@property NSMutableArray *events;
@property NSString *name;
@property NSMutableArray *budgetTable;

-(id) initWithName: (NSString*) n;
-(id) initWithName: (NSString*) n WithDescription: (NSString*) d;
-(void) addPeople: (NSString*) peopleName;
-(void) addEvent:(NSString*) eventName;
-(NSMutableArray*) getEventArray;
-(NSMutableArray*) getNameEntrys;
-(void) setPaid: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex;
-(void) setShouldPay: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex;
-(void) setEventToAverageCost:(int) eventIndex;
@end
