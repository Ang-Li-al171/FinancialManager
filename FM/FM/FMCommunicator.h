//
//  FMCommunicator.h
//  FM
//
//  Created by  mac on 9/29/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMCommunicator : NSObject <NSStreamDelegate> {
@public
	
	NSString *host;
	int port;
}

- (void)setup: (NSString *) messageToSend ;
- (void)close;
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event;
- (void)readIn:(NSString *)s;
- (void)writeOut:(NSString *)s;
- (BOOL) isDialogAvailable;
-(NSString*) getDialog;

@end