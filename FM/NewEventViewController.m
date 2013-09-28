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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewEvent:(id)sender {
    FMViewController *rootViewController = [self.navigationController.viewControllers objectAtIndex:0];
    
    
    //[[FMViewController alloc]initWithNibName:@"rootViewController" bundle:nil];
    
    rootViewController.myNewEventName = @"TESTING";
    rootViewController.myNewEventMemo = @"Still Testing";
    [rootViewController insertNewObject];
    
    //[self.navigationController popToViewController:rootViewController.navigationController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
