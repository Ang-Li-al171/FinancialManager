//
//  FMTrip.m
//  FM
//
//  Created by  mac on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMTrip.h"
#import "FMPair.h"
#import "FMBrain.h"

@implementation FMTrip

@synthesize peoples, events, name, budgetTable, description,brain;

-(id) initWithName: (NSString*) n WithBrain: (FMBrain*) b{
    self = [super init];
    name = n;
    brain = b;
    peoples = [[NSMutableArray alloc]init];
    events = [[NSMutableArray alloc] init];
    budgetTable = [[NSMutableArray alloc] init];
    return self;
}

-(id) initWithName: (NSString*) n WithDescription: (NSString*) d WithBrain: (FMBrain*) b{
    description = d;
    return [self initWithName:n WithBrain:b];
}

-(void) addPeople: (NSString*) peopleName{
    [peoples addObject:peopleName];
    for (NSMutableArray *e in budgetTable) {
        [e addObject: [[FMPair alloc ]init]];
    }
}

-(void) addPeoples: (NSString*) peopleNames{
    NSArray *names = [peopleNames componentsSeparatedByString:@","];
    for (NSString* n in names) {
        [self addPeople:n];
    }
}

-(void) addEvent:(NSString*) eventName{
    [events addObject:eventName];
    NSMutableArray *newEventEntry = [[NSMutableArray alloc] init];
    for (int i=0; i<peoples.count; i++) {
        [newEventEntry addObject:[[FMPair alloc]init]];
    }
    [budgetTable addObject: newEventEntry];
}

-(void) deleteEvent: (int) index{
    [events removeObjectAtIndex:index];
    [budgetTable removeObjectAtIndex:index];
}

-(NSMutableArray*) getEventArray{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:events];
    [array addObject:@"Total"];
    return array;
}

-(NSMutableArray*) getNameEntry: (NSString*) nameOfPeople{
    int index = (int)[peoples indexOfObject: nameOfPeople];
    int paidSum = 0;
    int shouldPaySum = 0;
    NSMutableArray *nameEntry = [[NSMutableArray alloc]init];
    [nameEntry addObject: nameOfPeople];
    for (NSMutableArray *e in budgetTable){
        FMPair *pair = [e objectAtIndex:index];
        NSString *str = [NSString stringWithFormat: @"%d/%d",pair.paid, pair.shouldPay];
        [nameEntry addObject:str];
        paidSum+= pair.paid;
        shouldPaySum+= pair.shouldPay;
    }
    [nameEntry addObject: [NSString stringWithFormat:@"%d",shouldPaySum-paidSum]];
    return nameEntry;
}

-(NSMutableArray*) getNameEntrys{
    NSMutableArray *nameEntrys = [[NSMutableArray alloc]init];
    for (NSString *n in peoples) {
        [nameEntrys addObject:[self getNameEntry:n]];
    }
    return nameEntrys;
}

-(void) setPaid: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex{
    ((FMPair*)[[budgetTable objectAtIndex:eventIndex] objectAtIndex: peopleIndex]).paid = money;
}

-(void) setShouldPay: (int) money WithEventIndex: (int) eventIndex WithPeopleIndex: (int) peopleIndex{
    ((FMPair*)[[budgetTable objectAtIndex:eventIndex] objectAtIndex: peopleIndex]).shouldPay = money;
}

-(void) setEventToAverageCost:(int) eventIndex {
    int sum = 0;
    for (FMPair *p in [budgetTable objectAtIndex:eventIndex]){
        sum=+p.paid;
    }
    for (FMPair *p in [budgetTable objectAtIndex:eventIndex]){
        p.shouldPay = sum/peoples.count;
    }
}

-(void) encodeWithCoder: (NSCoder*) coder {
    [coder encodeObject:name forKey:@"Name"];
    [coder encodeObject:description forKey:@"Description"];
    [coder encodeObject:peoples forKey:@"Peoples"];
    [coder encodeObject:events forKey:@"Events"];
    [coder encodeObject:budgetTable forKey:@"BudgetTable"];
}

-(id) initWithCoder:(NSCoder*) coder{
    self = [super init];
    name = [coder decodeObjectForKey:@"Name"];
    description = [coder decodeObjectForKey:@"Description"];
    peoples = [coder decodeObjectForKey:@"Peoples"];
    events = [coder decodeObjectForKey:@"Events"];
    budgetTable = [coder decodeObjectForKey:@"BudgetTable"];
    return self;
}



@end

