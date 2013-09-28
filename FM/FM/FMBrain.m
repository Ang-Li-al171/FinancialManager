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
    [trips addObject:[[Trip alloc] initWithName:tripName]];
}
-(void) addTripWithName:(NSString *)tripName WithDescription: (NSString*) tripDescp {
    [trips addObject:[[Trip alloc]initWithName:tripName WithDescription:tripDescp]];
}

-(Trip*) getTrip: (int) tripIndex {
    return [trips objectAtIndex:tripIndex];
}

-(NSMutableArray*) getTripNames{
    NSMutableArray* names = [[NSMutableArray alloc]init];
    for(Trip *t in trips){
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
    return self;
}

@end
