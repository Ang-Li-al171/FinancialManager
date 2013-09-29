//
//  FMBrain.h
//  FM
//
//  Created by  mac on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMTrip.h"

@interface FMBrain : NSObject

@property NSMutableArray *trips;

-(void) addTripWithName: (NSString*) name ;
-(void) addTripWithName:(NSString *)tripName WithDescription: (NSString*) tripDescp;
-(void) deleteTripWithIndex: (int) index;
-(NSMutableArray*) getTripNames;
-(FMTrip*) getTrip: (int) tripIndex ;
-(FMTrip*) getLastTrip;
-(void) encodeToFile:(NSString*) filePath;
-(id) initWithFile:(NSString*) filePath;
@end
