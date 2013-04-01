//
//  BookImageViewController.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScrollImageView.h"
#import "AudioBook.h"

@interface BookImageViewController : UIViewController <UIScrollViewDelegate, ScrollImageViewDelegate, ScrollImageViewDataSource> {
	ScrollImageView *imageScrollView;
	UIPageControl *pageControl;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;

	NSMutableArray *bookArray;
	int numberOfPages;
	
	float image_x_offset;
	float image_y_offset;
}

@property (nonatomic, retain) ScrollImageView *imageScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *bookArray;

-(void) addBookImage:(AudioBook*) book;
-(void) gotoPage:(int)page;

@end
