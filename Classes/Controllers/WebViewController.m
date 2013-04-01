//
//  WebViewController.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import "WebViewController.h"
#import "BookLibraryAppDelegate.h"


@interface WebViewController ()

- (BOOL) isModal;
- (void) done;

@end

@implementation WebViewController

@synthesize webView;
@synthesize urlAddress;

- (BOOL)isModal
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
	
    return rootViewController == self;
}

-(void) done
{
	BookLibraryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[[delegate navigationController] dismissViewControllerAnimated:YES completion:nil];
}


- (WebViewController*) initWithURLString:(NSString*) urlString
{
	self = [super init];
	self.urlAddress = urlString;
	
	return self;
}

#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	CGRect bounds = self.view.bounds;
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0,0.0,bounds.size.width, bounds.size.height)]; 
	// webView.backgroundColor = UIColorFromRGB(0xc0c0c0);
	webView.delegate = self;
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Request Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url] ;
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	[self.view addSubview:webView];
	
	if([self isModal]) 
	{
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								   target:self 
								   action:@selector(done)];
		[[self navigationItem] setRightBarButtonItem:doneButton];
		[doneButton release];
	}
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	UIAlertView *charAlert = [[UIAlertView alloc]
							  initWithTitle:@"Error Loading URL"
							  message:[NSString stringWithFormat:@"Error loading: %@",
										[error localizedDescription]]
							  delegate:nil
							  cancelButtonTitle:@"Done"
							  otherButtonTitles:nil];
	
	[charAlert show];
	[charAlert autorelease];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
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


- (void)dealloc 
{
	[urlAddress release];
	webView.delegate = nil;
	[webView release];
    [super dealloc];
}

@end
