//
//  PlayAudioBookController.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import "PlayAudioBookController.h"
#import "BookLibraryTableController.h"
#import "BookLibraryAppDelegate.h"
#import "SavedAudioBook.h"

@interface PlayAudioBookController ()

-(void) showDescription:(AudioBook *)book;
-(void) showOtherInfo:(AudioBook*)book;

@end

@implementation PlayAudioBookController

@synthesize textView;
@synthesize player;
@synthesize progressUpdateTimer;
@synthesize audioControlView;
@synthesize buttonBar;
@synthesize segmentedControl;
@synthesize bookMenuController;
@synthesize bookMenuPopover;

@synthesize fetchedResultsController, managedObjectContext;
@synthesize bookImageViewController;


-(void)viewDidLoad
{	
	[super viewDidLoad];
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light-wood.jpg"]];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																						   target:self action:@selector(add:)];
	
    CGRect bounds = [[self view] bounds];
	
	CGRect audioControlRect = CGRectMake(0.0, 0.0, bounds.size.width, 200.0);
	audioControlView = [[AudioControlView alloc]initWithFrame:audioControlRect];
	audioControlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	audioControlView.delegate = self;
	[[self view] addSubview:audioControlView];
	
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
    progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
														 selector:@selector(updateSlider) userInfo:nil repeats:YES];
	
	buttonBar = [UIToolbar new];
	buttonBar.barStyle = UIBarStyleBlack;
	buttonBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[buttonBar sizeToFit];
	buttonBar.frame = CGRectMake(0, 210, bounds.size.width, 50);
	
	[self.view addSubview:buttonBar];
	[buttonBar release];
	
	//Create the segmented control
	NSArray *itemArray = [NSArray arrayWithObjects: @"Description", @"Author", @"Other Info", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.frame = CGRectMake(200, 210, bounds.size.width-400, 50);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	segmentedControl.tintColor = [UIColor darkGrayColor];
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self
	                     action:@selector(pickOne:)
	           forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:segmentedControl];
	
	CGRect rect = CGRectMake(0.0, 260.0, bounds.size.width, bounds.size.height-220);
	textView = [[UIWebView alloc] initWithFrame:rect];
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[textView setOpaque:NO];
	[textView setDataDetectorTypes:UIDataDetectorTypeAll];
	[textView setBackgroundColor:[UIColor clearColor]];
	
	[textView setUserInteractionEnabled:YES];
	[[self view] addSubview:textView];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	if(player) {
		[player stop];
	}
}

-(void) viewWillDisappear:(BOOL)animated 
{
	if(player) 
	{
		[player stop];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/**
 * Sent to the view controller just before
 * the user interface begins rotating.
 */
- (void)willAnimateRotationToInterfaceOrientation:
			(UIInterfaceOrientation)interfaceOrientation
			duration:(NSTimeInterval)duration 
{
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}



//Action method executes when user touches the button
- (void) pickOne:(id)sender
{
	if(currentBook == nil) 
	{
		return;
	}
	UISegmentedControl *sc = (UISegmentedControl *)sender;
	int index = [sc selectedSegmentIndex];
	switch (index) 
	{
		case 0:
			[self showDescription:currentBook];
			break;
		case 1:
		{
			NSString *urlAddress = [currentBook AuthorURL];
			
			//Create a URL object.
			NSURL *url = [NSURL URLWithString:urlAddress];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			
			//Load the request in the UIWebView.
			[textView loadRequest:requestObj];
		}	
			break;
		case 2:
			[self showOtherInfo:currentBook];
			break;
		default:
			break;
	}
} 

-(void) stop
{
	[player stop];
}

-(void) play
{
	[player start];
}

-(void) pause
{
	[player pause];
}

-(void) forward:(int)seekValue
{
	if (player.duration)
    {
		double newSeekTime = 0.0;
		if(seekValue != 0)
		{
			newSeekTime = (seekValue / 100.0) * player.duration;
		} else {
			newSeekTime = player.progress + 30.0;
		}
        [player seekToTime:newSeekTime];
    }
}

-(void) error:(NSString *)reason
{
	NSLog(@"Error while playing audio stream:%@", reason);
	// Change button state
	if(player) {
		// should we retry??
		[player stop];
		[player release];
	}
	[audioControlView reset];
	//Re-initialize
	// player = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:currentBook.zipfile]];
}


- (void)updateSlider 
{
    // Update the slider about the music time
	if(player)
	{
		double progress = player.progress;
		double duration = player.duration;
		[audioControlView updateSlider:progress duration:duration];
	}
}

-(void)playAudioBook:(AudioBook*)book
{
	if(player) 
	{
		[player stop];
		[player release];
	}
	currentBook = book;
	NSLog(@"Playing audio book:%@", book.zipfile);
	player = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:book.zipfile]];
	
	[self showDescription:currentBook];
}

- (void) showDescription:(AudioBook*)book
{
	NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
								   "<head> \n"
								   "<style type=\"text/css\"> \n"
								   "body { \n"
								   "font-family:helvetica; \n"
								   "font-size: 1.5em; \n"
								   "}\n"   
								   "</style> \n"
								   "</head> \n"
								   "<body><h1 align=\"center\">%@</h1>%@</body> \n"
								   "</html>", [book title], [book desc]];
	[textView loadHTMLString:myDescriptionHTML baseURL:[NSURL URLWithString:[book url]]];
}

- (void) showOtherInfo:(AudioBook *)book
{
	NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
								   "<head> \n"
								   "<style type=\"text/css\"> \n"
								   "body { \n"
								   "font-family:helvetica; \n"
								   "font-size: 1.5em; \n"
								   "}\n"   
								   "</style> \n"
								   "</head> \n"
								   "<body> \n"
								   "<h1 align=\"center\">%@</h1> \n"
								   "<ul> \n"
								   "<li><b>Genre</b>:%@ </li> \n"
								   "<li><b>Wiki URL</b>:%@ </li> \n"
								   "<li><b>Author URL</b>:%@ </li> \n"
								   "</ul> \n"
								   "</body> \n"
								   "</html>", [book title], [book Genre], [book WikiBookURL], [book AuthorURL]];
	[textView loadHTMLString:myDescriptionHTML baseURL:[NSURL URLWithString:[book url]]];
}

// BookMenuTableDelegate protocol
-(void) addToBookmarks
{
	[self addBookmark];
	[self.bookMenuPopover dismissPopoverAnimated:YES];
}

-(void) add:(id) sender
{
	if (bookMenuController == nil) 
	{
        self.bookMenuController = [[[BookMenuTableController alloc] 
							 initWithStyle:UITableViewStylePlain] autorelease];
        bookMenuController.delegate = self;
        self.bookMenuPopover = [[[UIPopoverController alloc] 
									initWithContentViewController:bookMenuController] autorelease];               
    }
    [self.bookMenuPopover presentPopoverFromBarButtonItem:sender 
									permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
  
-(void) addBookmark
{
	[self createBookmark:currentBook];
}

-(void) createBookmark:(AudioBook*)book
{
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"SavedAudioBook" inManagedObjectContext:moc];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	// Set predicate
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url like %@", book.url];
	[request setPredicate:predicate];
	
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if ((array != nil) && ([array count] != 0))
	{
		SavedAudioBook *ab = [array objectAtIndex:0];
		NSLog(@"ExISTS - url:%@", ab.description);
	} else {
		NSLog(@"Does not exist");
	
		SavedAudioBook *bookmark = 
			(SavedAudioBook *)[NSEntityDescription insertNewObjectForEntityForName:@"SavedAudioBook" inManagedObjectContext:managedObjectContext];

		bookmark.bookid = book.bookid;
		bookmark.title = book.title;
		bookmark.author = book.author;
		bookmark.desc = book.description;	
		bookmark.ArchiveOrgURL = book.ArchiveOrgURL;
		bookmark.GutenburgURL = book.GutenburgURL;
		bookmark.zipfile = book.zipfile;
		bookmark.WikiBookURL = book.WikiBookURL;
		bookmark.AuthorURL = book.AuthorURL;
		bookmark.ForumURL = book.ForumURL;
		bookmark.OtherURL = book.OtherURL;
		bookmark.Category = book.Category;
		bookmark.Genre = book.Genre;
		bookmark.NumberOfSections = book.NumberOfSections;
		bookmark.reader = book.reader;
		bookmark.rssurl = book.rssurl;
		bookmark.url = book.url;
	 
		error = nil;
		if (![managedObjectContext save:&error]) 
		{
			// Handle the error.
			NSLog(@"ERROR");
		}
		BookLibraryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		BookImageViewController *imageViewController = [delegate bookImageViewController];
		[imageViewController addBookImage:book];
	}
}


- (void)dealloc 
{
	bookMenuPopover = nil;
	bookMenuController = nil;
	
	[progressUpdateTimer invalidate];
	[progressUpdateTimer release];
	
	if(player) {
		[player release];
	}
	
	[bookImageViewController release];
	[audioControlView release];
	[textView release];
	
	[managedObjectContext release];
    [super dealloc];
}


@end
