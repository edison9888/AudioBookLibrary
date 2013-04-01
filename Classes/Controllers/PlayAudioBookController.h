//
//  PlayAudioBookController.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BookImageViewController.h"
#import "BookMenuTableController.h"
#import "AudioBook.h"
#import "AudioStreamer.h"
#import "AudioControlView.h"

@interface PlayAudioBookController : UIViewController <UITabBarDelegate, AudioControlDelegate, AudioStreamerDelegate, 
														NSFetchedResultsControllerDelegate, BookMenuTableDelegate> 
{
	
	UIWebView * textView;
	UIToolbar *buttonBar;
	UISegmentedControl *segmentedControl;
	AudioControlView *audioControlView;
	
	AudioStreamer* player;
	NSTimer *progressUpdateTimer;
	AudioBook *currentBook;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	BookImageViewController *bookImageViewController;
	UIPopoverController *bookMenuPopover;
	BookMenuTableController *bookMenuController;
															
}
	
@property (nonatomic, retain) UIPopoverController *bookMenuPopover;
@property (nonatomic, retain) BookMenuTableController *bookMenuController;
@property (nonatomic, retain) BookImageViewController *bookImageViewController;


@property (nonatomic, retain) UIWebView * textView;
@property (nonatomic, retain) UIToolbar *buttonBar;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) AudioControlView *audioControlView;

@property (nonatomic, retain) AudioStreamer *player;
@property (nonatomic, retain) NSTimer *progressUpdateTimer;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void) playAudioBook:(AudioBook*)book;
-(void) createBookmark:(AudioBook*)book;

@end
