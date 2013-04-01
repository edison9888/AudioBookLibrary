//
//  ScrollImageView.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//

#include "ThumbImageView.h"

@protocol ScrollImageViewDelegate;
@protocol ScrollImageViewDataSource;


@interface ScrollImageView : UIScrollView <ThumbImageViewDelegate> {
	id<ScrollImageViewDelegate> viewDelegate;
	id<ScrollImageViewDataSource> dataSource;
	NSMutableArray *imageArray;
	
	int numberOfImages;
	int numberOfPages;
	int rows;
	int columns;
	
	CGSize imageSize;
	CGFloat widthPadding;
	CGFloat heightPadding;
}

@property (nonatomic, assign) id <ScrollImageViewDelegate> viewDelegate;
@property (nonatomic, assign) id <ScrollImageViewDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGFloat widthPadding, heightPadding;

-(int) numberOfPages;
-(void) addImage:(int)tag;
-(void) showCloseIcons;
-(void) doneShowCloseIcons;
- (id)initWithDelegate:(id<ScrollImageViewDelegate>)del andDataSource:(id<ScrollImageViewDataSource>)datasource andFrame:(CGRect)frame;

@end

@protocol ScrollImageViewDelegate <NSObject>
-(CGSize) imageSize;
-(CGFloat) widthPadding;
-(CGFloat) heightPadding;
-(NSString*) getImageName:(int)tag;
-(NSString*) getTitle:(int)tag;
-(void) addPage;
-(void) selectedBook:(int)tag;

@optional

@end

@protocol ScrollImageViewDataSource <NSObject>
-(int) numberOfImages;
-(void) removeElement:(int)tag;
@optional

@end