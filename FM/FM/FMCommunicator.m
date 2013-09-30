//
//  FMCommunicator.m
//  FM
//
//  Created by  mac on 9/29/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMCommunicator.h"

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

NSString * message;
NSString * msgFromServer;
NSString * iSay;
BOOL dialogAvailable;
NSString * dialog = @"";
static BOOL didSayWord;

@implementation FMCommunicator

- (void)setup: (NSString *) messageToSend {
    msgFromServer = @"";
    iSay = @"";
    dialogAvailable = NO;
    didSayWord = NO;
    message = messageToSend;
	NSURL *url = [NSURL URLWithString:host];
	
	NSLog(@"Setting up connection to %@ : %i", [url absoluteString], port);
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)[url host], port, &readStream, &writeStream);
	
	if(!CFWriteStreamOpen(writeStream)) {
		NSLog(@"Error, writeStream not open");
		return;
	}
	[self open];
	
	NSLog(@"Status of outputStream: %u", [outputStream streamStatus]);
	
	return;
}

- (void)open {
	NSLog(@"Opening streams.");
	
	inputStream = (__bridge NSInputStream *)readStream;
	outputStream = (__bridge NSOutputStream *)writeStream;
	
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
    [inputStream open];
    [outputStream open];
    
    
    NSStreamStatus status =[inputStream streamStatus];
    if(status == NSStreamStatusClosed || status == NSStreamStatusError)
    {
        NSLog(@"Error: %u", status);
    }
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
}

- (void)close {
	NSLog(@"Closing streams.");
	
	[inputStream close];
	[outputStream close];
	
	[inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
	[inputStream setDelegate:nil];
	[outputStream setDelegate:nil];
	
	inputStream = nil;
	outputStream = nil;
    
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event {
    
	NSLog(@"Stream triggered.");
	
	switch(event) {
		case NSStreamEventHasSpaceAvailable: {
			if(stream == outputStream) {
				NSLog(@"outputStream is ready.");
                NSString* blah = [NSString stringWithFormat: @"%@\n", message ];
                if([blah length] && !didSayWord) {
                    uint8_t *buf = (uint8_t *)[blah UTF8String];
                    NSInteger nwritten = [outputStream write:buf maxLength:strlen((char *)buf)];
                    if (-1 == nwritten) {
                        NSLog(@"Error writing to stream %@: %@", outputStream, [outputStream streamError]);
                    } else {
                        NSLog(@"Wrote %ld bytes to stream %@.", (long)nwritten, outputStream);
                    }
                }
                didSayWord = YES;
			}
			break;
		}
		case NSStreamEventHasBytesAvailable: {
			if(stream == inputStream) {
				NSLog(@"inputStream is ready.");
				uint8_t buf[1024];
				unsigned int len = 0;
				len = (int)[inputStream read:buf maxLength:1024];
				if(len > 0) {
					NSMutableData* data=[[NSMutableData alloc] initWithLength:0];
					[data appendBytes: (const void *)buf length:len];
					NSString *s = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
					[self readIn:s];
                    [self close];
				}
            }
			break;
		}
        case NSStreamEventErrorOccurred: {
            NSLog(@"an error occurred. %@ :(",[stream streamError]);
            break;
        }
		default: {
			NSLog(@"Stream is sending an Event: %u", event);
			break;
		}
	}
}

- (BOOL) isDialogAvailable{
    return dialogAvailable;
}

-(NSString*) getDialog{
    return dialog;
}

- (void)readIn:(NSString *)s {
	NSLog(@"Reading in the following:");
	NSLog(@"%@", s);
    dialog = s;
    dialogAvailable = YES;
}

- (void)writeOut:(NSString *)s {
	uint8_t *buf = (uint8_t *)[s UTF8String];
	
	[outputStream write:buf maxLength:strlen((char *)buf)];
	
	NSLog(@"Writing out the following:");
	NSLog(@"%@", s);
}

@end
