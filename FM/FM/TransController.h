//
//  TransController.h
//  FM
//
//  Created by Ang Li on 9/28/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)pressSubmit:(id)sender;

@end
