//
//  BookLibraryAppDelegate.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//

#import "BookLibraryAppDelegate.h"
#import "BookLibraryTableController.h"
#import "PlayAudioBookController.h"
#import "HTTPConnection.h"

@interface BookLibraryAppDelegate ()

// private methods
-(void) initializeUserDefaults;

@end


@implementation BookLibraryAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize splitViewController;
@synthesize tabBarController;
@synthesize bookImageViewController;

@synthesize activityView;

#pragma mark -
#pragma mark AppDelegate methods

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[self initializeUserDefaults];	
		
	// add views
	BookLibraryTableController *tableController = [[BookLibraryTableController alloc] initWithStyle:UITableViewStyleGrouped];
	
	// New tabbar controller and array to contain the view controllers
	// There are two (2) view controllers needed
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:2];
	
	/*--------------------------------------------------------------------
	 * Setup the 2 view controllers for the different data representations
	 *-------------------------------------------------------------------*/
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:tableController];
	
	//navigationController.tabBarItem.image = [UIImage imageNamed:@"author-icon.png"];
	navigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
	
	// Add navigation controller to the local vc array (1 of 2)
	[localViewControllersArray addObject:navigationController];
	
	bookImageViewController = [[BookImageViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:bookImageViewController];
	// navigationController.tabBarItem.image = [UIImage imageNamed:@"description-icon.png"];
	navigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
	[bookImageViewController release];   // This is now managed by the navigation controller 
	
	// Add navigation controller to the vc array (2 of 2)
	[localViewControllersArray addObject:navigationController];
	
	// Point the tab bar controllers view controller array to the array
	// of view controllers we just populated
	tabBarController.viewControllers = localViewControllersArray;
	[localViewControllersArray release]; // Retained thru above setter
	
    window.rootViewController = tabBarController;
    
	//post init
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	[tableController release];
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	[tabBarController release];
	[navigationController release];
	
    [window release];
    [super dealloc];
	
}

#pragma mark -
#pragma mark BookLibraryAppDelegate public methods

-(void)hideActivityViewer
{
	[[[activityView subviews] objectAtIndex:0] stopAnimating];
	[activityView removeFromSuperview];
	activityView = nil;
}

-(void)showActivityViewer
{
	[activityView release];
	activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
	activityView.backgroundColor = [UIColor blackColor];
	activityView.alpha = 0.5;
	
	UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
	activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									  UIViewAutoresizingFlexibleRightMargin |
									  UIViewAutoresizingFlexibleTopMargin |
									  UIViewAutoresizingFlexibleBottomMargin);
	[activityView addSubview:activityWheel];
	[activityWheel release];
	[window addSubview: activityView];
	[activityView release];
	
	[[[activityView subviews] objectAtIndex:0] startAnimating];
}

static UIAlertView *sAlert = nil;

- (void)alert:(NSString*)title message:(NSString*)message
{
    if (sAlert) return;
	
    sAlert = [[UIAlertView alloc] initWithTitle:title
                                        message:message
									   delegate:self
							  cancelButtonTitle:@"Close"
							  otherButtonTitles:nil];
    [sAlert show];
    [sAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    sAlert = nil;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark AppDelegate private methods

-(void) initializeUserDefaults
{
    
    // check for network connectivity
	BOOL isNetworkDataSourceAvailable  = [HTTPConnection isNetworkDataSourceAvailable:@"www.archive.org"];
	if(isNetworkDataSourceAvailable == NO)
	{
		[self alert:@"Network error" message:@"Cannot connect to the network source. Please check network connection."];
	}

}


#pragma mark -
#pragma mark AppDelegate static methods

+(BookLibraryAppDelegate*)getAppDelegate
{
    return (BookLibraryAppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark AppDelegate CoreData methods

//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
											   stringByAppendingPathComponent: @"AudioBooks.sqlite"]];
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel:[self managedObjectModel]];
	if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												 configuration:nil URL:storeUrl options:nil error:&error]) {
		/*Error for store creation should be handled in here*/
	}
	
	return persistentStoreCoordinator;
}



@end

