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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.catePicker.delegate = self;
    self.catePicker.dataSource = self;
    self.catePicker.showsSelectionIndicator = YES;
    
    
    for(int i = 0; i < self.myPeoples.count; i++){
        UILabel *label =  [[UILabel alloc] initWithFrame:
                           CGRectMake(185, 380+350*i/self.myPeoples.count, 140, 21)];
        label.text = [self.myPeoples objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor grayColor];
        [self.view addSubview:label];
    }
    
    self.myTextFields = [[NSMutableArray alloc] init];
    self.myShouldPayFields = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.myPeoples.count; i++){
        UITextField *textIn =  [[UITextField alloc] initWithFrame:
                                CGRectMake(370, 380+350*i/self.myPeoples.count, 150, 21)];
        textIn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textIn];
        [self.myTextFields addObject:textIn];
        
        UITextField *textShouldPay =  [[UITextField alloc] initWithFrame:
                                CGRectMake(540, 380+350*i/self.myPeoples.count, 150, 21)];
        textShouldPay.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textShouldPay];
        [self.myShouldPayFields addObject:textShouldPay];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
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


//- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    //Here, like the table view you can get the each section of each row if you've multiple sections
//    NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
//    
//    //Now, if you want to navigate then;
//    // Say, OtherViewController is the controller, where you want to navigate:
//    OtherViewController *objOtherViewController = [OtherViewController new];
//    [self.navigationController pushViewController:objOtherViewController animated:YES];
//    
//}

- (IBAction)pressSubmit:(id)sender {
    NSInteger num = self.navigationController.viewControllers.count-2;
    FMCollection *collectionController = [self.navigationController.viewControllers objectAtIndex:num];
    
    int row = [self.catePicker selectedRowInComponent:0];
    
    [collectionController.myTrip addEvent: [self switchCate:row]];
    
    int shouldPay=0;
    if (self.splitAll.isOn){
        shouldPay = [self.totalCostInput.text intValue]/self.myPeoples.count;
    }
    for (int i=0; i<self.myPeoples.count;i++){
        UITextField *field = (UITextField*)([self.myTextFields objectAtIndex:i]);
        [collectionController.myTrip setPaid: [field.text intValue] WithEventIndex:[collectionController.myTrip getEventArray].count-2 WithPeopleIndex:i];
        if (!self.splitAll.isOn){
            UITextField *shouldField = (UITextField*)([self.myShouldPayFields objectAtIndex:i]);
            shouldPay = [shouldField.text intValue];
        }
        [collectionController.myTrip setShouldPay:shouldPay WithEventIndex:[collectionController.myTrip getEventArray].count-2 WithPeopleIndex:i];
    }
    
    [collectionController refresh];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPeopleList:(NSMutableArray *) peoples{
    self.myPeoples = peoples;
}

@end
