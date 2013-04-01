//
//  BookLibraryTableController.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/09.
//  Copyright 2009 Vivek Nagar. All rights reserved.
//

#import "BookLibraryAppDelegate.h"
#import "BookLibraryTableController.h"
#import "PlayAudioBookController.h"
#import "ActivityView.h"
#import "FetchAudioBooks.h"
#import "CustomTableCell.h"


@implementation BookLibraryTableController

@synthesize tableData;
@synthesize activityView;
@synthesize bookSearchBar;
@synthesize labelView;

const NSString* searchString = @"http://librivox.org/newcatalog/search_xml.php?extended=1&simple=";

- (void)dealloc {
    [tableData dealloc];
	[bookSearchBar release];
	[activityView release];
	[labelView release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad
{
	[super viewDidLoad];
	CGRect bounds = [self.view bounds];
	
	UIImageView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light-wood.jpg"]] autorelease];
	self.tableView.backgroundView = view;
	self.tableView.backgroundColor = [UIColor clearColor];
	
	labelView = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width/2-100, bounds.size.height/2 -50, 200, 100)];
	labelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | 
								 UIViewAutoresizingFlexibleRightMargin | 
								 UIViewAutoresizingFlexibleTopMargin | 
								 UIViewAutoresizingFlexibleBottomMargin;
	labelView.text = @"No audio books.\nUse search bar to search for books.";
	labelView.backgroundColor = [UIColor clearColor];
	labelView.font = [UIFont boldSystemFontOfSize:20];
	labelView.lineBreakMode = NSLineBreakByWordWrapping;
	labelView.numberOfLines = 0;
	[self.tableView.backgroundView addSubview:labelView];

	tableData = [[NSMutableArray alloc] initWithCapacity:10];
	
	UINavigationBar *navBar = [[self navigationController] navigationBar];
	UIColor *navigationBarColor = [[UIColor alloc] initWithRed:0.454 green:0.329 blue:0.211 alpha:1.0];
	navBar.tintColor = navigationBarColor;
	[navigationBarColor release];
	
	CGRect navBarBounds = navBar.bounds;
	float searchBarWidth = navBarBounds.size.width/4;
	float searchBarHeight = navBarBounds.size.height;
	
	bookSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(bounds.size.width - searchBarWidth, 0.0, searchBarWidth, searchBarHeight)];
	bookSearchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
	// [navBar addSubview:bookSearchBar];
	
	self.navigationItem.title = @"AudioBooks";
    bookSearchBar.placeholder = @"Search authors, books or stations";
	bookSearchBar.delegate = self;
	
	UIBarButtonItem *searchBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookSearchBar] autorelease];
	self.navigationItem.rightBarButtonItem = searchBarButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	bookSearchBar.hidden = NO;
}	

// Override inherited method to enable/disable edit button
- (void) setEditing:(BOOL)editing
		   animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	UIBarButtonItem *editButton = [[self navigationItem] rightBarButtonItem];
	[editButton setEnabled:!editing];
}


-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	bookSearchBar.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/**
 * Sent to the view controller just before
 * the user interface begins rotating.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration 
{
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}	


#pragma mark -
#pragma mark UITableViewDataSource protocol

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows = [tableData count];
	if(rows == 0) {
		labelView.hidden = NO;
	} else {
		labelView.hidden = YES;
	}
	return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Audiobooks";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell"];
			
	if(cell == nil)
	{
		cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PersonalCell"];
		[cell autorelease];
	}
	
	NSUInteger index = [indexPath row];
	AudioBook *book = [tableData objectAtIndex:index];
	
	[[cell textLabel] setText:[book title]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	UIImageView* label = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
	label.frame = CGRectMake(0, 0, 20, 20);
	cell.accessoryView = label;
	[label release];

	return cell;
}


// Return YES to allow reordering of table view rows
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath*) indexPath
{
	return YES;
}

//Invoked when the user drags one of the table view cells. Mirror the change by updating the array of displayed objects.
- (void) tableView: (UITableView*) tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)targetIndexPath
{
}

// Update array of displayed objects by inserting/removing objects as necessary
-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//Notifies the delegate when the user selects a row
-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSUInteger index = [indexPath row];
	AudioBook *book = [tableData objectAtIndex:index];
	
	BookLibraryAppDelegate* audioBookDelegate = [[UIApplication sharedApplication] delegate];
	PlayAudioBookController *playAudioBookController = [[PlayAudioBookController alloc] init];
	playAudioBookController.managedObjectContext = [audioBookDelegate managedObjectContext];
	[[self navigationController] pushViewController:playAudioBookController animated:YES];
	[playAudioBookController playAudioBook:book];
	[playAudioBookController release];
}

#pragma mark -
#pragma mark UISearchBarDelegate Protocol

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	FetchAudioBooks* fetchBooks = [[FetchAudioBooks alloc] init];
	fetchBooks.delegate = self; // set delegate to populate book data
	
	NSString *result = searchBar.text;
	[fetchBooks getBooks:[NSString stringWithFormat:@"%@%@", searchString, result]];
	
	activityView = [[ActivityView alloc] initWithFrame:CGRectMake(175.0, 175.0, 75.0, 75.0)];
	[self.tableView addSubview:activityView];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
	self.tableView.alpha = 0.5;
}

#pragma mark -
#pragma mark FetchBooksDelegate Protocol

- (void)finishedLoadingBooks:(NSMutableArray *)books {
	self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
	self.tableView.alpha = 1.0;
	[activityView close];
	[activityView release];
	
	[self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:books];
    [self.tableView reloadData];
}

@end
