//
//  BookImageViewController.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BookImageViewController.h"
#import "BookLibraryAppDelegate.h"
#import "ScrollImageView.h"
#import "PlayAudioBookController.h"
#import "SavedAudioBook.h"
#import "UIViewAdditions.h"

@interface BookImageViewController ()

-(void) loadSavedBooks;

@end


@implementation BookImageViewController

@synthesize imageScrollView;
@synthesize pageControl;
@synthesize fetchedResultsController, managedObjectContext;
@synthesize bookArray;

const float IMAGE_WIDTH = 120.0;
const float IMAGE_HEIGHT = 160.0;

-(void) loadSavedBooks
{
	[bookArray removeAllObjects];
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"SavedAudioBook" inManagedObjectContext:moc];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if ((array != nil) && ([array count] != 0))
	{
		[bookArray addObjectsFromArray:array];
	} else {
		NSLog(@"No audio books in the database.");
	}
}

#pragma mark -
#pragma mark UIViewController Methods

-(void)loadView
{
	[super loadView];
	
	BookLibraryAppDelegate* audioBookDelegate = [[UIApplication sharedApplication] delegate];
	self.managedObjectContext = audioBookDelegate.managedObjectContext;
	
	bookArray = [[NSMutableArray alloc] init];
	[self loadSavedBooks];
	image_x_offset = 30.0;
	image_y_offset = 20.0;
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light-wood.jpg"]];
	
	UIColor *navigationBarColor = [[UIColor alloc] initWithRed:0.454 green:0.329 blue:0.211 alpha:1.0];
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	navigationBar.tintColor = navigationBarColor;

	CGRect bounds = self.view.bounds;

	self.navigationItem.title = @"Bookmarks";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	imageScrollView = [[ScrollImageView alloc] initWithDelegate:self andDataSource:self andFrame:CGRectMake(0.0,0.0,bounds.size.width, bounds.size.height-40)];
	imageScrollView.userInteractionEnabled = YES;
	imageScrollView.pagingEnabled = YES;
	imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	numberOfPages = [imageScrollView numberOfPages];
	NSLog(@"Number of Pages:%d", numberOfPages);
	
	[self.view addSubview:imageScrollView];
		
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, bounds.size.height - 124, bounds.size.width, 40)];
    pageControl.numberOfPages = numberOfPages;    
    pageControl.currentPage = 0;
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    pageControl.backgroundColor = [UIColor blackColor];    
	[self.view addSubview:pageControl];

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
	image_x_offset = 30;
	image_y_offset = 20;
	UIDevice *device = [UIDevice currentDevice];
	if([device orientation] == UIDeviceOrientationLandscapeLeft || [device orientation] == UIDeviceOrientationLandscapeRight)
	{
		image_x_offset = 40;
		image_y_offset = 10;
	}
	
    CGRect bounds = [self.view bounds];
    imageScrollView.frame = CGRectMake(0.0,0.0,bounds.size.width, bounds.size.height - 40);
    pageControl.frame = CGRectMake(0, bounds.size.height - 44, bounds.size.width, 44);
	[self gotoPage:pageControl.currentPage];
}	

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	// Updates the appearance of the Edit|Done button as necessary.
	[super setEditing:editing animated:animated];
	
	// [self.view printSubviewsOfView];
	
	if(editing)
	{
		[imageScrollView showCloseIcons];
	} else {
		[imageScrollView doneShowCloseIcons];
		[self loadSavedBooks];
	}
}

-(void) selectedBook:(int)tag
{
	BookLibraryAppDelegate* audioBookDelegate = [[UIApplication sharedApplication] delegate];
	PlayAudioBookController *playAudioBookController = [[PlayAudioBookController alloc] init];
	playAudioBookController.managedObjectContext = [audioBookDelegate managedObjectContext];

	[[self navigationController] pushViewController:playAudioBookController animated:YES];

	[playAudioBookController playAudioBook:[bookArray objectAtIndex:tag]];
	[playAudioBookController release];
}

-(void) addBookImage:(AudioBook*) book
{
	[bookArray addObject:book];
	int tag = [bookArray count] - 1;
	[imageScrollView addImage:tag];	
}

-(void) removeElement:(int)tag
{
	SavedAudioBook *book = [bookArray objectAtIndex:tag];
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
		NSLog(@"Book with title:%@ exists.", ab.title);
		[managedObjectContext deleteObject:ab];
		error = nil;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
			NSLog(@"Cannot save to persistent store.");
		}
		[bookArray removeObjectAtIndex:tag];
	} else {
		NSLog(@"Audio book does not exist");
	}
}

- (NSString*) getTitle:(int)tag
{
	SavedAudioBook* ab = [bookArray objectAtIndex:tag];
    return ab.title;
}

- (NSString*) getImageName:(int)tag
{
    return @"Default.png";
}

- (CGFloat) widthPadding
{
    return image_x_offset;
}

- (CGFloat) heightPadding
{
    return image_y_offset;
}

- (CGSize) imageSize
{
    return CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
}

- (int) numberOfImages
{
    return [bookArray count];
}

-(void) addPage {
    numberOfPages++;
    pageControl.numberOfPages++;
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
    CGRect bounds = [self.view bounds];
    CGPoint offset = aScrollView.contentOffset;
    pageControl.currentPage = offset.x / (bounds.size.width);
}

-(void) gotoPage:(int) page {
	CGRect bounds = [self.view bounds];
    pageControl.currentPage = page;
	
    self.imageScrollView.contentOffset = CGPointMake(bounds.size.width * page, 0.0f);	
}

-(void) pageTurn: (UIPageControl*) aPageControl {
    CGRect bounds = [self.view bounds];
    int whichPage = aPageControl.currentPage;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.imageScrollView.contentOffset = CGPointMake(bounds.size.width * whichPage, 0.0f);
    [UIView commitAnimations];
}

- (void)dealloc 
{
	[imageScrollView release];
	[pageControl release];
	[bookArray release];
    [super dealloc];
}


@end

