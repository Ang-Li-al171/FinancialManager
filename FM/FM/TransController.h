//
//  TransController.h
//  FM
//
//  Created by Ang Li on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UISwitch *splitAll;
@property (weak, nonatomic) IBOutlet UIPickerView *catePicker;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBarTrans;

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *transNameInput;
@property (weak, nonatomic) IBOutlet UITextField *totalCostInput;
@property (weak, nonatomic) IBOutlet UILabel *transName;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (strong, nonatomic) NSMutableArray *myPeoples;
@property (strong, nonatomic) NSMutableArray *myTextFields;
@property (strong, nonatomic) NSMutableArray *myShouldPayFields;

@property bool repeated;
@property int myRow;

- (IBAction)pressSubmit:(id)sender;
- (void)setPeopleList:(NSMutableArray *) peoples;
- (NSString*) switchCate: (int) num;
- (void) setSecondTime:(bool)isRepeated;

@end
