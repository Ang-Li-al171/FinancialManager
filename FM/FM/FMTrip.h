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
#import "FMBrain.h"

@interface FMTrip : NSObject

@property NSString * description;
@property NSMutableArray *peoples;
@property NSMutableArray *events;
@property NSString *name;
@property NSMutableArray *budgetTable;
@property FMBrain *brain;


-(id) initWithName: (NSString*) n WithBrain: (FMBrain*) b;
-(id) initWithName: (NSString*) n WithDescription: (NSString*) d WithBrain: (FMBrain*) b;
-(void) addPeople: (NSString*) peopleName;
-(void) addPeoples: (NSString*) peopleNames;
-(void) addEvent:(NSString*) eventName;
-(void) deleteEvent: (int) index;
-(NSMutableArray*) getEventArray;
-(NSMutableArray*) getNameEntrys;
-(void) setPaid: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex;
-(void) setShouldPay: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex;
-(void) setEventToAverageCost:(int) eventIndex;
@end

