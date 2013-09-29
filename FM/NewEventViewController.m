//
//  NewEventViewController.m
//  FM
//
//  Created by Sherry Wenshun Liu on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "NewEventViewController.h"
#import "FMViewController.h"
#import "ATTSpeechKit.h"
#import "SpeechConfig.h"
#import "SpeechAuth.h"
#import "FMTrip.h"

@interface NewEventViewController () {
    NSString *CurrentButton;
}
- (void) speechAuthFailed: (NSError*) error;
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

// Initialize SpeechKit for this app.
- (void) prepareSpeech
{
    // Access the SpeechKit singleton.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    // Point to the SpeechToText API.
    speechService.recognitionURL = SpeechServiceUrl();
    
    // Hook ourselves up as a delegate so we can get called back with the response.
    speechService.delegate = self;
    
    // Use default speech UI.
    speechService.showUI = YES;
    
    // Choose the speech recognition package.
    speechService.speechContext = @"sms";
    
    // Enable the Speex codec, which provides better speech recognition accuracy.
    speechService.audioFormat = ATTSKAudioFormatSpeex_WB;
    
    // Start the OAuth background operation, disabling the Talk button until
    // it's done.
    _nameButton.enabled = NO;
    [[SpeechAuth authenticatorForService: SpeechOAuthUrl()
                                  withId: @"6utcxczquelrylmo347yaxkyogd4tohw"
                                  secret: @"jyetzfmrtcyyxilsvj76gqh9ucpofsov"
                                   scope: SpeechOAuthScope()]
     fetchTo: ^(NSString* token, NSError* error) {
         if (token) {
             NSLog(@"correct token");
             speechService.bearerAuthToken = token;
             _nameButton.enabled = YES;
         }
         else
             [self speechAuthFailed: error];
     }];
    
    // Wake the audio components so there is minimal delay on the first request.
    [speechService prepare];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CurrentButton = @"";
    [self prepareSpeech];
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
    
    // let the trip know
    [rootViewController.myBrain addTripWithName:_nameText.text WithDescription:_memoText.text];
    [[rootViewController.myBrain getLastTrip] addPeoples:_memberText.text];
    
    // letting the home screen know
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

//listening to speech

- (IBAction)listenToName:(id)sender {
    NSLog(@"Starting speech request");
    CurrentButton = @"Name";
    
    // Start listening via the microphone.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    [speechService startListening];
}
- (IBAction)listenToMemo:(id)sender {
    NSLog(@"Starting speech request");
    CurrentButton = @"Memo";
    
    // Start listening via the microphone.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    [speechService startListening];
}

- (void) handleRecognition: (NSString*) recognizedText
{
    // Display the recognized text.
    //NSLog(recognizedText);
    if ([CurrentButton isEqualToString:@"Name"]) {
        [self.nameText setText:recognizedText];
    } else if ([CurrentButton isEqualToString:@"Memo"]){
        [self.memoText setText:recognizedText];
    }
}

- (void) speechServiceSucceeded: (ATTSpeechService*) speechService
{
    NSLog(@"Speech service succeeded");
    
    // Extract the needed data from the SpeechService object:
    // For raw bytes, read speechService.responseData.
    // For a JSON tree, read speechService.responseDictionary.
    // For the n-best ASR strings, use speechService.responseStrings.
    
    // In this example, use the ASR strings.
    // There can be 0 strings, 1 empty string, or 1 non-empty string.
    // Display the recognized text in the interface is it's non-empty,
    // otherwise have the user try again.
    NSArray* nbest = speechService.responseStrings;
    NSString* recognizedText = @"";
    if (nbest != nil && nbest.count > 0)
        recognizedText = [nbest objectAtIndex: 0];
    if (recognizedText.length) { // non-empty?
        [self handleRecognition: recognizedText];
    }
    else {
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle: @"Didn't recognize speech"
                                   message: @"Please try again."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
    }
}

- (void) speechService: (ATTSpeechService*) speechService
       failedWithError: (NSError*) error
{
    if ([error.domain isEqualToString: ATTSpeechServiceErrorDomain]
        && (error.code == ATTSpeechServiceErrorCodeCanceledByUser)) {
        NSLog(@"Speech service canceled");
        // Nothing to do in this case
        return;
    }
    NSLog(@"Speech service had an error: %@", error);
    
    UIAlertView* alert =
    [[UIAlertView alloc] initWithTitle: @"An error occurred"
                               message: @"Please try again later."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
}

/* The SpeechAuth authentication failed. */
- (void) speechAuthFailed: (NSError*) error
{
    NSLog(@"OAuth error: %@", error);
    UIAlertView* alert =
    [[UIAlertView alloc] initWithTitle: @"Speech Unavailable"
                               message: @"This app was rejected by the speech service.  Contact the developer for an update."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
}


@end
