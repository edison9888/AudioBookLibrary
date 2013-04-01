//
//  BookMenuTableController.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookMenuTableDelegate
-(void)addToBookmarks;
@end

@interface BookMenuTableController : UITableViewController {
	NSMutableArray *menuItems;
	id<BookMenuTableDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *menuItems;
@property (nonatomic, assign) id<BookMenuTableDelegate> delegate;

@end
