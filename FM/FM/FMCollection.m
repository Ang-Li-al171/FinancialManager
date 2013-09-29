//
//  FMCollection.m
//  FM
//
//  Created by  mac on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMCollection.h"
#import "FMCell.h"
#import "IconButton.h"
#import "CollectionFlowLayout.h"
#import "FMTrip.h"
#import "TransController.h"
#import "menuButton.h"
#import <QuartzCore/QuartzCore.h>

#import "ATTSpeechKit.h"
#import "SpeechConfig.h"
#import "SpeechAuth.h"

@interface FMCollection () {
    UIButton *speakButton;
    UITextField *mySpeechField;
    UITextView *myDiscussionBoard;
    UIButton *sendButton;
}
- (void) speechAuthFailed: (NSError*) error;
@end

@interface UIColor (MyProject)

+(UIColor *) colorForSomePurpose;

@end

@implementation UIColor (MyProject)

+(UIColor *) colorForSomePurpose { return [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1.0]; }

@end

@implementation FMCollection

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
    speakButton.enabled = NO;
    [[SpeechAuth authenticatorForService: SpeechOAuthUrl()
                                  withId: @"6utcxczquelrylmo347yaxkyogd4tohw"
                                  secret: @"jyetzfmrtcyyxilsvj76gqh9ucpofsov"
                                   scope: SpeechOAuthScope()]
     fetchTo: ^(NSString* token, NSError* error) {
         if (token) {
             NSLog(@"correct token");
             speechService.bearerAuthToken = token;
             speakButton.enabled = YES;
         }
         else
             [self speechAuthFailed: error];
     }];
    
    // Wake the audio components so there is minimal delay on the first request.
    [speechService prepare];
}



- (void)initWithTripPtr:(FMTrip *)tripPtr{
    self.myTrip = tripPtr;
    self.myTransButtons = [[NSMutableArray alloc] init];
    self.myTransControllers = [[NSMutableArray alloc] init];
   
}

//define size for each cell
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        return CGSizeMake(60, 60);
    }
    else{
        CGRect mainRect = [[UIScreen mainScreen] bounds];
        CGFloat mainWidth = mainRect.size.width;
        return CGSizeMake(((mainWidth-10*(self.myTrip.peoples.count+1))-80)/(self.myTrip.peoples.count), 60);
    }
}

//returns the number of sections
-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView{
    return self.myTrip.peoples.count+1;
}

//return the num of items in each section
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numItems+1;
}

//return cell for each specific index path
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IconButton* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myButton" forIndexPath:indexPath];
        
        int picNum = 3; //default is 3, payment icon
        //change pic based on type
        if (indexPath.row < self.numItems && indexPath.row > 0)
            picNum = [self switchCate:[[self.myTrip getEventArray] objectAtIndex:indexPath.row-1]];
        [aCell.myButton setImage:self.PICArray[picNum] forState:UIControlStateNormal];
        [aCell.myButton setBackgroundColor:[UIColor underPageBackgroundColor]];
        
        if (0 < indexPath.row && indexPath.row < self.numItems){
            
            [self.myTransButtons insertObject:aCell.myButton atIndex:0];
            menuButton * lastaddedButton = [self.myTransButtons objectAtIndex:0];
            [lastaddedButton setMyRowNum:indexPath.row];
            [lastaddedButton addTarget:self action:@selector(pressTransButton:) forControlEvents:UIControlEventTouchDown];
        }
        
        // UI apperance
        aCell.backgroundColor = [UIColor clearColor];
        [[aCell.myButton layer] setCornerRadius:15.0f];
        [[aCell.myButton layer] setBorderWidth:4.0f];
        [[aCell.myButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        return aCell;
    }
    else{
        FMCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        aCell.myLabel.text = [[[self.myTrip getNameEntrys] objectAtIndex: (indexPath.section-1)] objectAtIndex: indexPath.row];
        
        // UI appearance
        [[aCell layer] setCornerRadius:15.0f];
        [[aCell layer] setBorderWidth:2.0f];
        [[aCell layer] setBorderColor:[UIColor grayColor].CGColor];
        return aCell;
    }
}

- (void)setFlowAndItemSize{

    UICollectionViewFlowLayout *flowLayout = [[CollectionFlowLayout alloc] init];
    
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"collectionBG.jpg"]];
    self.naviBarCollection.title = [NSString stringWithFormat:@"%@%@", @"Transactions: ", self.myTrip.name];
    
    self.DEFAULT_TRANS_PIC = [UIImage imageNamed:@"transaction_6060.png"];
    self.DINING = [UIImage imageNamed:@"restaurant_icon_6060.png"];
    self.HOTEL = [UIImage imageNamed:@"Hotel Icon black_6060.png"];
    self.FUN = [UIImage imageNamed:@"icon-attraction_6060.png"];
    self.SHOPPING = [UIImage imageNamed:@"shopping_cart_icon_6060.jpg"];
    
    self.PICArray = @[self.DINING, self.HOTEL, self.FUN, self.DEFAULT_TRANS_PIC, self.SHOPPING];

    self.numItems = [self.myTrip getEventArray].count;
    
    [self setFlowAndItemSize];
    
    myDiscussionBoard = [[UITextView alloc]initWithFrame:CGRectMake(50, 400, 660, 300)];
    myDiscussionBoard.backgroundColor = [UIColor colorForSomePurpose];
    myDiscussionBoard.editable = FALSE;
    myDiscussionBoard.scrollEnabled = YES;
    [self.collectionView addSubview:myDiscussionBoard];
    
    mySpeechField = [[UITextField alloc] initWithFrame:CGRectMake(50, 360, 660, 40)];
    mySpeechField.borderStyle = UITextBorderStyleRoundedRect;
    mySpeechField.font = [UIFont systemFontOfSize:20];
    mySpeechField.textColor = [UIColor blackColor];
    [self.view addSubview:mySpeechField];
    
    speakButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [speakButton setFrame:CGRectMake(20, 300, 100, 50)];
    [speakButton addTarget:self
                    action:@selector(listen)
          forControlEvents:UIControlEventTouchDown];
    [speakButton setTitle:@"Hold To Speak" forState:UIControlStateNormal];
    [self.view addSubview:speakButton];
    
    
    sendButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [sendButton setFrame:CGRectMake(400, 300, 100, 50)];
    [sendButton addTarget:self
                    action:@selector(sendMessage)
          forControlEvents:UIControlEventTouchDown];
    [sendButton setTitle:@"Send!" forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    [self prepareSpeech];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refresh
{
    self.numItems = [self.myTrip getEventArray].count;
    self.myTransButtons = [[NSMutableArray alloc] init];
    [self.collectionView reloadData];
}

//brings to the details page
- (void)pressTransButton:(id)sender{
    menuButton *myself = (menuButton *) sender;
    TransController* page = [self.myTransControllers objectAtIndex:myself.myRowNum-1];
    [page setSecondTime: true];
    [self.navigationController pushViewController:page animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"addTrans"])
    {
        // Get reference to the destination view controller
        TransController *vc = [segue destinationViewController];
        [vc setSecondTime:false];
        // Pass any objects to the view controller here, like...
        [vc setPeopleList:self.myTrip.peoples];
    }
}


- (int) switchCate: (NSString*) str {
    int pic = 0;
    if ([str isEqualToString:@"Dining"])
        pic = 0;
    else if ([str isEqualToString:@"Hotel"])
        pic = 1;
    else if ([str isEqualToString:@"Fun Park"])
        pic = 2;
    else if ([str isEqualToString:@"Payment"])
        pic = 3;
    else if ([str isEqualToString:@"Shopping"])
        pic = 4;
    return pic;
}

- (IBAction)sendMessage {
    NSString *message = mySpeechField.text;
    
    NSString *originalMessage = myDiscussionBoard.text;
    if (!originalMessage) {
        NSString *updatedMessage = message;
        [myDiscussionBoard setText:updatedMessage];
    } else {
        NSString *updatedMessage = [NSString stringWithFormat:@"%@\n%@", originalMessage, message];
        [myDiscussionBoard setText:updatedMessage];
    }
    mySpeechField.text = @"";
}


//listening to speech

- (IBAction)listen {
    NSLog(@"Starting speech request");
    
    // Start listening via the microphone.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    [speechService startListening];
}

- (void) handleRecognition: (NSString*) recognizedText
{
    // Display the recognized text.
    [mySpeechField setText:recognizedText];
    
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
