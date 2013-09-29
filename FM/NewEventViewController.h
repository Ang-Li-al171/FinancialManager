//
//  NewEventViewController.h
//  FM
//
//  Created by Sherry Wenshun Liu on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEventViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *image;
}

@property (strong, nonatomic) IBOutlet UIView *createNewEventView;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoLibraryBarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *memoText;
@property (weak, nonatomic) IBOutlet UITextField *memberText;

- (IBAction)chooseExistingBarButton:(id)sender;

- (IBAction)createNewEvent:(id)sender;

@end
