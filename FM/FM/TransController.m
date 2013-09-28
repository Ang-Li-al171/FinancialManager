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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressSubmit:(id)sender {
        NSInteger num = self.navigationController.viewControllers.count-2;
        FMCollection *collectionController = [self.navigationController.viewControllers objectAtIndex:num];
        
        collectionController.myNewTransName = @"TESTING";
        [collectionController createNewObj];
        
        [self.navigationController popViewControllerAnimated:YES];
}
@end
