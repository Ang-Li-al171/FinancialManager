//
//  FMViewController.m
//  FM
//
//  Created by Sherry Wenshun Liu on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMViewController.h"
#import "CustomHomeCell.h"
#import "FMCollection.h"
#import "ATTSpeechKit.h"
#import "SpeechConfig.h"
#import "SpeechAuth.h"

@interface FMViewController ()
{
    NSMutableArray *TitleLabel;
    NSMutableArray *DescriLabel;
    NSMutableArray *TransactionPage;
}
- (void) speechAuthFailed: (NSError*) error;

@end

@implementation FMViewController
@synthesize myHomeTableView;


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
    speechService.speechContext = @"WebSearch";
    
    // Enable the Speex codec, which provides better speech recognition accuracy.
    speechService.audioFormat = ATTSKAudioFormatSpeex_WB;
    
    // Start the OAuth background operation, disabling the Talk button until
    // it's done.
    _talkButton.enabled = NO;
    [[SpeechAuth authenticatorForService: SpeechOAuthUrl()
                                  withId: @"6utcxczquelrylmo347yaxkyogd4tohw"
                                  secret: @"jyetzfmrtcyyxilsvj76gqh9ucpofsov"
                                   scope: SpeechOAuthScope()]
     fetchTo: ^(NSString* token, NSError* error) {
         if (token) {
             NSLog(@"correct token");
             speechService.bearerAuthToken = token;
             _talkButton.enabled = YES;
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
    
    [self prepareSpeech];
    
    self.myHomeTableView.dataSource = self;
    self.myHomeTableView.delegate = self;
    
    TitleLabel = [[NSMutableArray alloc] initWithObjects:@"Porto Rico", @"San Diego", nil];
    DescriLabel = [[NSMutableArray alloc] initWithObjects:@"A lot of fun", @"Spring Break 2013", nil];
    _image = [UIImage imageNamed:@"defaultEventPic.png"];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FMCollection *fm = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    FMCollection *fmTwo = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    
    //FMCollection *transaction = [[FMCollection alloc] initWithNibName:nil bundle:nil];
    TransactionPage = [[NSMutableArray alloc] initWithObjects:fm, fmTwo, nil];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToNewEventPage)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Create cells

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TitleLabel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    CustomHomeCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!Cell) {
        Cell = [[CustomHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Cell.TitleLabel.text = [TitleLabel objectAtIndex:indexPath.row];
    Cell.DescriLabel.text = [DescriLabel objectAtIndex:indexPath.row];

    Cell.imageView.image = _image;
    _image = [UIImage imageNamed:@"defaultEventPic.png"];
    
    return Cell;
}

//Editing cells

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [myHomeTableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [TitleLabel removeObjectAtIndex:indexPath.row];
        [DescriLabel removeObjectAtIndex:indexPath.row];
        [TransactionPage removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

//Add new cells
- (void)goToNewEventPage {
    [self performSegueWithIdentifier:@"EventCreater" sender:self];
}

- (void)insertNewObject {
    if (!TitleLabel) {
        TitleLabel = [[NSMutableArray alloc] init];
    }
    [TitleLabel insertObject:_myNewEventName atIndex:0];
    
    if (!DescriLabel) {
        DescriLabel = [[NSMutableArray alloc] init];
    }
    [DescriLabel insertObject:_myNewEventMemo atIndex:0];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FMCollection *fm = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    [TransactionPage insertObject:fm atIndex:0];
    
    //add to table view
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myHomeTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//go to transaction page

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path: %d", indexPath.row);
    FMCollection* page = [TransactionPage objectAtIndex:indexPath.row];
    NSLog(@"array size: %d", TransactionPage.count);
    [self.navigationController pushViewController:page animated:YES];
}

//listening to speech

- (IBAction)listen:(id)sender {
    NSLog(@"Starting speech request");
    
    // Start listening via the microphone.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    // Add extra arguments for speech recogniton.
    // The parameter is the name of the current screen within this app.
    //speechService.xArgs = [NSDictionary dictionaryWithObjectsAndKeys: @"main", @"ClientScreen", nil];
    
    [speechService startListening];
}

- (void) handleRecognition: (NSString*) recognizedText
{
    // Display the recognized text.
    //NSLog(recognizedText);
    
    [self.talkDisplayLabel setText:recognizedText];
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
