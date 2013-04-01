//
//  BookLibraryAppDelegate.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/09.
//  Copyright Vivek Nagar 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BookImageViewController.h"

@interface BookLibraryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	UISplitViewController *splitViewController;
	UITabBarController *tabBarController;
	
	BookImageViewController *bookImageViewController;
	UIView *activityView;
	UIImageView *splashView;
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) BookImageViewController *bookImageViewController;

@property (nonatomic, retain) UIView *activityView;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//public methods
- (NSString *)applicationDocumentsDirectory;

-(void) hideActivityViewer;
-(void) showActivityViewer;
-(void) alert:(NSString*)title message:(NSString*)detail;

//static methods
+ (BookLibraryAppDelegate*)getAppDelegate;

@end




