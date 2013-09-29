//
//  FMViewController.h
//  FM
//
//  Created by Sherry Wenshun Liu on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTSpeechKit.h"

@interface FMViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ATTSpeechServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myHomeTableView;

@property(nonatomic) NSString *myNewEventName;
@property(nonatomic) NSString *myNewEventMemo;
@property(nonatomic) NSString *myNewEventMember;
@property(nonatomic) UIImage *image;
- (IBAction)listen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet UILabel *talkDisplayLabel;

- (IBAction)insertNewObject;

@end
