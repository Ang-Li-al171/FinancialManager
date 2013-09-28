//
//  FMViewController.h
//  FM
//
//  Created by Sherry Wenshun Liu on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myHomeTableView;

@property(nonatomic) NSString *myNewEventName;
@property(nonatomic) NSString *myNewEventMemo;

- (IBAction)insertNewObject;

@end
