//
//  NewEventViewController.m
//  FM
//
//  Created by Sherry Wenshun Liu on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "NewEventViewController.h"
#import "FMViewController.h"

@interface NewEventViewController ()
    
@end

@implementation NewEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseExistingBarButton:(id)sender {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    [pickerLibrary setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerLibrary.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pickerLibrary];
        
        [popover presentPopoverFromBarButtonItem: self.photoLibraryBarButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
        self.popOver = popover;
    } else {
        [self presentViewController:pickerLibrary animated:YES completion:NULL];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)createNewEvent:(id)sender {
    FMViewController *rootViewController = [self.navigationController.viewControllers objectAtIndex:0];
    
    rootViewController.myNewEventName = _nameText.text;
    rootViewController.myNewEventMemo = _memoText.text;
    rootViewController.myNewEventMember = _memberText.text;
    
    if (!image){
        image = [UIImage imageNamed:@"defaultEventPic.png"];
    }
    rootViewController.image = image;
    [rootViewController insertNewObject];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
