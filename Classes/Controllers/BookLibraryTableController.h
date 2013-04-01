//
//  BookLibraryTableController.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchAudioBooks.h"
#import "ActivityView.h"

@interface BookLibraryTableController : UITableViewController <UISearchBarDelegate, UITableViewDataSource, FetchBooksDelegate> {
	NSMutableArray *tableData;
	
	ActivityView *activityView;
	UISearchBar *bookSearchBar;
	UILabel *labelView;
}

@property (nonatomic, retain) NSMutableArray *tableData;

@property (nonatomic, retain) ActivityView *activityView;
@property (nonatomic, retain) UISearchBar *bookSearchBar;
@property (nonatomic, retain) UILabel *labelView;

@end
