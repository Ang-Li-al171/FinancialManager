//
//  NewEventViewController.h
//  FM
//
//  Created by Sherry Wenshun Liu on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTSpeechKit.h"

@interface NewEventViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ATTSpeechServiceDelegate> {
    UIImage *image;
}

@property (strong, nonatomic) IBOutlet UIView *createNewEventView;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoLibraryBarButton;


@property (weak, nonatomic) IBOutlet UIButton *nameButton;
- (IBAction)listenToName:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UIButton *memoButton;
- (IBAction)listenToMemo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *memoText;

@property (weak, nonatomic) IBOutlet UITextField *memberText;

- (IBAction)chooseExistingBarButton:(id)sender;

- (IBAction)createNewEvent:(id)sender;

@end
