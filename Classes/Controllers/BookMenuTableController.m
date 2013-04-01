//
//  BookMenuTableController.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import "BookMenuTableController.h"
#import "CustomTableCell.h"

@implementation BookMenuTableController

@synthesize menuItems;
@synthesize delegate;

- (void)dealloc {
    [menuItems dealloc];
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.backgroundColor = [UIColor clearColor];
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(200.0, 40.0);
	self.menuItems = [NSMutableArray array];
	[menuItems addObject:@"Add to Bookmarks"];
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
	int rows = [menuItems count];
	return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
			
	if(cell == nil)
	{
		cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MenuCell"];
		[cell autorelease];
	}
	
	NSUInteger index = [indexPath row];
	NSString *item = [menuItems objectAtIndex:index];
	
	[[cell textLabel] setText:item];

	return cell;
}


//Notifies the delegate when the user selects a row
-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
	[delegate addToBookmarks];
}

@end
