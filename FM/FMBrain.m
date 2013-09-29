//
//  FMBrain.m
//  FM
//
//  Created by  mac on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//
#import "FMBrain.h"
#import "FMTrip.h"

@implementation FMBrain

@synthesize trips;

-(void) addTripWithName: (NSString*) tripName {
    [trips addObject:[[FMTrip alloc] initWithName:tripName]];
}
-(void) addTripWithName:(NSString *)tripName WithDescription: (NSString*) tripDescp {
    [trips addObject:[[FMTrip alloc]initWithName:tripName WithDescription:tripDescp]];
}

-(void) deleteTripWithIndex: (int) index{
    [trips removeObjectAtIndex:index];
}

-(FMTrip*) getTrip: (int) tripIndex {
    return [trips objectAtIndex:tripIndex];
}
-(FMTrip*) getLastTrip {
    return [trips objectAtIndex:trips.count-1];
}

-(NSMutableArray*) getTripNames{
    NSMutableArray* names = [[NSMutableArray alloc]init];
    for(FMTrip *t in trips){
        [names addObject:t.name];
    }
    return names;
}

-(void) encodeToFile:(NSString*) filePath{
    [NSKeyedArchiver archiveRootObject:trips toFile:filePath];
}
-(id) initWithFile:(NSString*) filePath{
    self = [super init];
    trips = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (trips==NULL) trips = [[NSMutableArray alloc] init];
    return self;
}

@end
