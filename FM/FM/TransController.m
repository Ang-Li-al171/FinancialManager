//
//  TransController.m
//  FM
//
//  Created by Ang Li on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "TransController.h"
#import "FMCollection.h"

@interface TransController ()

@end

@implementation TransController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setSecondTime:(bool)isRepeated{
    self.repeated = isRepeated;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"transBG.jpg"]];
    
    self.catePicker.delegate = self;
    self.catePicker.dataSource = self;
    self.catePicker.showsSelectionIndicator = YES;
    
    
    for(int i = 0; i < self.myPeoples.count; i++){
        UILabel *label =  [[UILabel alloc] initWithFrame:
                           CGRectMake(100, 380+350*i/self.myPeoples.count, 140, 30)];
        label.text = [self.myPeoples objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor clearColor];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        UIFont *futuraFont = [UIFont fontWithName:@"futura" size:18.0];
        label.font = futuraFont;
        [self.view addSubview:label];
    }
    
    self.myTextFields = [[NSMutableArray alloc] init];
    self.myShouldPayFields = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.myPeoples.count; i++){
        UITextField *textIn =  [[UITextField alloc] initWithFrame:
                                CGRectMake(300, 380+350*i/self.myPeoples.count, 150, 30)];
        textIn.backgroundColor = [UIColor whiteColor];
        textIn.textColor = [UIColor blackColor];
        textIn.textAlignment = UITextAlignmentCenter;
        [textIn setBorderStyle:UITextBorderStyleRoundedRect];
        [self.view addSubview:textIn];
        [self.myTextFields addObject:textIn];
        
        UITextField *textShouldPay =  [[UITextField alloc] initWithFrame:
                                CGRectMake(500, 380+350*i/self.myPeoples.count, 150, 30)];
        textShouldPay.backgroundColor = [UIColor whiteColor];
        textShouldPay.textColor = [UIColor blackColor];
        textShouldPay.textAlignment = UITextAlignmentCenter;
        [textShouldPay setBorderStyle:UITextBorderStyleRoundedRect];
        [self.view addSubview:textShouldPay];
        [self.myShouldPayFields addObject:textShouldPay];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self switchCate: row];
}

- (NSString*) switchCate: (int) num {
    NSString * title = nil;
    switch(num) {
        case 0:
            title = @"Dining";
            break;
        case 1:
            title = @"Hotel";
            break;
        case 2:
            title = @"Fun Park";
            break;
        case 3:
            title = @"Payment";
            break;
        case 4:
            title = @"Shopping";
            break;
    }
    return title;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressSubmit:(id)sender {
    NSInteger num = self.navigationController.viewControllers.count-2;
    FMCollection *collectionController = [self.navigationController.viewControllers objectAtIndex:num];
    
    // set the title of the navigation bar
    self.naviBarTrans.title = [NSString stringWithFormat:@"%@%@", @"Details: ", self.transNameInput.text];
    
    int row = [self.catePicker selectedRowInComponent:0];
    
    // if this is a new event, add event to controller.mytrip and set myrow.
    if (!self.repeated){
        [collectionController.myTrip addEvent: [self switchCate:row]];
        self.myRow = [collectionController.myTrip getEventArray].count;
    }else{
        [collectionController.myTrip.events replaceObjectAtIndex:self.myRow-2 withObject:[self switchCate:row]];
    }
    
    int shouldPay=0;
    if (self.splitAll.isOn){
        shouldPay = [self.totalCostInput.text intValue]/self.myPeoples.count;
    }
    for (int i=0; i<self.myPeoples.count;i++){
        UITextField *field = (UITextField*)([self.myTextFields objectAtIndex:i]);
        [collectionController.myTrip setPaid: [field.text intValue] WithEventIndex:self.myRow-2 WithPeopleIndex:i];
        if (!self.splitAll.isOn){
            UITextField *shouldField = (UITextField*)([self.myShouldPayFields objectAtIndex:i]);
            shouldPay = [shouldField.text intValue];
        }
        [collectionController.myTrip setShouldPay:shouldPay WithEventIndex:self.myRow-2 WithPeopleIndex:i];
    }
    
    // if this is a new event, add it to list of transControllers.
    if (!self.repeated){
        [collectionController.myTransControllers addObject: self];
    }
    [collectionController refresh];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPeopleList:(NSMutableArray *) peoples{
    self.myPeoples = peoples;
}

@end
