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

#import "FMBrain.h"
#import "FMTrip.h"

@interface FMViewController ()
{
    NSMutableArray *TitleLabel;
    NSMutableArray *DescriLabel;
    NSMutableArray *TransactionPage;
}

@end

@interface UIColor (MyProject)

+(UIColor *) colorForSomePurpose;

@end

@implementation UIColor (MyProject)

+(UIColor *) colorForSomePurpose { return [UIColor colorWithRed:0.95 green:0.69 blue:0.41 alpha:1.0]; }

@end

@implementation FMViewController
@synthesize myHomeTableView, myBrain;


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
    
    self.myBrain = [[FMBrain alloc] initWithFile:@"/User/angli/Desktop/data.plist"];
    self.myHomeTableView.dataSource = self;
    self.myHomeTableView.delegate = self;
    
    TitleLabel = [[NSMutableArray alloc] initWithObjects:@"Best Event", @"Sample Event", nil];
    DescriLabel = [[NSMutableArray alloc] initWithObjects:@"Sherry->Candy Crush, Ang->sleep, Yaqi->eat", @"Big Byte Challenge is Awesome", nil];
    
    _image = [UIImage imageNamed:@"defaultEventPic.png"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FMCollection *fm = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    FMCollection *fmTwo = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    
    [self.myBrain addTripWithName:TitleLabel[0] WithDescription:DescriLabel[0]];
    [fm initWithTripPtr: [self.myBrain getLastTrip]];
    [self.myBrain addTripWithName:TitleLabel[1] WithDescription:DescriLabel[1]];
    [fmTwo initWithTripPtr: [self.myBrain getLastTrip]];
    
    [fm.myTrip addPeoples:@"Ang Li, jjjjack, oooops"];
    [fmTwo.myTrip addPeoples:@"Monsters, Cars, Nemo"];
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
    
    Cell.contentView.backgroundColor=[UIColor colorForSomePurpose] ;
    
    if (!Cell) {
        Cell = [[CustomHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *attributes = [(NSAttributedString *)Cell.TitleLabel.attributedText attributesAtIndex:0 effectiveRange:NULL];
    NSString *updateTitle = [TitleLabel objectAtIndex:indexPath.row];
    Cell.TitleLabel.attributedText = [[NSAttributedString alloc] initWithString:updateTitle attributes:attributes];
    Cell.DescriLabel.text = [DescriLabel objectAtIndex:indexPath.row];

    Cell.eventImageView.image = _image;
    Cell.eventImageView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    // create a new CollectionViewController and link it with trip
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FMCollection *fm = [sb instantiateViewControllerWithIdentifier:@"FMCollection"];
    [fm initWithTripPtr:[self.myBrain getLastTrip]];
    [TransactionPage insertObject:fm atIndex:0];
    
    //add to table view
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myHomeTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//go to transaction page

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"index path: %d", indexPath.row);
    FMCollection* page = [TransactionPage objectAtIndex:indexPath.row];
    //NSLog(@"array size: %d", TransactionPage.count);
    [self.navigationController pushViewController:page animated:YES];
    [myHomeTableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
