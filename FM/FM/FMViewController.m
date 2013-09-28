//
//  FMViewController.m
//  FM
//
//  Created by Sherry Wenshun Liu on 9/27/13.
//  Copyright (c) 2013 Duke CS. All rights reserved.
//

#import "FMViewController.h"
#import "CustomHomeCell.h"

@interface FMViewController ()
{
    NSMutableArray *TitleLabel;
    NSMutableArray *DescriLabel;
}

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


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSLog(@"did go here");
    
    self.myHomeTableView.dataSource = self;
    self.myHomeTableView.delegate = self;
    
    TitleLabel = [[NSMutableArray alloc] initWithObjects:@"Porto Rico", @"San Diego", nil];
    DescriLabel = [[NSMutableArray alloc] initWithObjects:@"A lot of fun", @"Spring Break 2013", nil];
    
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
    Cell.imageView.image = [UIImage imageNamed:@"pic.jpg"];
    
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
    
    //add to table view
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myHomeTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //TO BE REVISED
    
    if (buttonIndex == 1) { //refer to OK button
        //get String
        NSString * tmpTextField = [alertView textFieldAtIndex:0].text;
        
        //insert String to Mutable Array
        if (!TitleLabel) {
            TitleLabel = [[NSMutableArray alloc] init];
        }
        [TitleLabel insertObject:tmpTextField atIndex:0];
                //better at 0. Mutable array will then shift everything forward 1
        
        if (!DescriLabel) {
            DescriLabel = [[NSMutableArray alloc] init];
        }
        [DescriLabel insertObject:@"place holder" atIndex:0];
        
        //add to table view
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.myHomeTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
