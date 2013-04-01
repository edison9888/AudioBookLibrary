//
//  ScrollImageView.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import "ScrollImageView.h"
#import "NSThreadAdditions.h"

@interface ScrollImageView ()
-(void) baseInit;
-(void) computeLayoutGeometry;
@end;

@implementation ScrollImageView
@synthesize imageArray;
@synthesize viewDelegate;
@synthesize dataSource;
@synthesize imageSize;
@synthesize widthPadding, heightPadding;

- (id)initWithDelegate:(id<ScrollImageViewDelegate>)del andDataSource:(id<ScrollImageViewDataSource>)datasource 
			  andFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		imageArray = [[NSMutableArray alloc] init];
		numberOfPages = 0;
		rows = 0;
		columns = 0;
		self.viewDelegate = del;
		self.dataSource = datasource;
		
		numberOfImages = [dataSource numberOfImages];
		imageSize = [viewDelegate imageSize];
		heightPadding = [viewDelegate heightPadding];
		widthPadding = [viewDelegate widthPadding];
		
		[self computeLayoutGeometry];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		imageArray = [[NSMutableArray alloc] init];
		numberOfPages = 0;
		rows = 0;
		columns = 0;
    }
    return self;
}

  
-(void) addImage:(int)tag {
	CGRect bounds = [self bounds];
	
	NSString *imgFile = [viewDelegate getImageName:tag];
	UIImage *img = [UIImage imageNamed:imgFile];

	NSString *title =[viewDelegate getTitle:tag];
	
	int numberOfImagesInLastPage = numberOfImages - (numberOfPages*rows*columns);

	if(numberOfImages % (rows*columns) == 0) {
		numberOfPages++;
		[self.viewDelegate addPage];
		self.contentSize = CGSizeMake(numberOfPages*bounds.size.width, bounds.size.height);
	} 
	numberOfImages++;
	numberOfImagesInLastPage++;
		
	rows = numberOfImagesInLastPage/columns;
	int remainder = numberOfImagesInLastPage%columns;
	float x = 0.0;
	float y = 0.0;
	if(remainder == 0) {
		//last column
		y = (rows-1)*(imageSize.height + 2*heightPadding) + heightPadding;
		x = (bounds.size.width)*(numberOfPages-1) + (columns-1)*(imageSize.width + 2*widthPadding) + widthPadding;
	} else {
		y = (rows)*(imageSize.height + 2*heightPadding) + heightPadding;
		x = (bounds.size.width)*(numberOfPages-1) + (remainder-1)*(imageSize.width + 2*widthPadding) + widthPadding;
	}
	// NSLog(@"Adding IMAGE:%f,%f", x, y);
	ThumbImageView *imgView = [[ThumbImageView alloc] initWithFrame:CGRectMake(x, y, imageSize.width, imageSize.height)];
	imgView.imageView.image = img;
	imgView.labelView.text = title;
	imgView.tag = numberOfImages-1;
	imgView.delegate = self;
	
	[self addSubview:imgView];
	[imageArray addObject:imgView];
	[imgView release];
	
}

- (void)baseInit {
	CGRect bounds = [self bounds];
	BOOL create = NO;
	if([imageArray count] == 0) {
		create = YES;
	}
	
	int currCount = 0;
	int remainder = 0;
	float x, y;
	int currRows = rows;
	int currColumns = columns;
	
	for(int k = 0; k < numberOfPages; k++) 
	{
		x = k*bounds.size.width + widthPadding;
		y = heightPadding;
		if(k == numberOfPages-1) {
			remainder = numberOfImages - currCount;
			currRows = remainder/currColumns;
		}
		for(int j = 0; j < currRows+1; j++)
		{
			if(j == currRows) {
				if(k < numberOfPages-1)
					break;
				remainder = numberOfImages - currCount;
				currColumns = remainder;
			}
			for(int i = 0; i < currColumns; i++)
			{
				// NSLog(@"page:%d, row:%d, column:%d", k, j, i);
				if(create) {
					NSString *imgFile = [viewDelegate getImageName:currCount];
					NSString *title =[viewDelegate getTitle:currCount];
					
					UIImage *img = [UIImage imageNamed:imgFile];
										
					ThumbImageView *imgView = [[ThumbImageView alloc] initWithFrame:CGRectMake(x, y, imageSize.width, imageSize.height)];
					imgView.imageView.image = img;
					imgView.labelView.text = title;
					imgView.tag = currCount;
					imgView.delegate = self;
					[self addSubview:imgView];
					[imageArray addObject:imgView];
					[imgView release];
					// TODO release imgFile, title, img?
				} else {
					ThumbImageView *imgView = [imageArray objectAtIndex:currCount];
					CGContextRef context = UIGraphicsGetCurrentContext();
					[UIView beginAnimations:nil context:context];
					[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
					[UIView setAnimationDuration:1.0];
					imgView.frame = CGRectMake(x, y, imageSize.width, imageSize.height);
					[UIView commitAnimations];
				}

				x = x + imageSize.width + 2*widthPadding;
				currCount++;
			}
			y = y + imageSize.height + 2*heightPadding;
			x = k*bounds.size.width + widthPadding;
		}
	}
	
}

- (void)computeLayoutGeometry {		
	CGRect bounds = [self bounds];
	float width = bounds.size.width;
	float height = bounds.size.height;
	NSLog(@"WIDTH:%f, HEIGHT:%f", width, height);
	
	columns = width/(imageSize.width + 2*widthPadding);
	rows = height/(imageSize.height + 2*heightPadding);
	int numberOfImagesInPage = columns*rows;
	
	numberOfPages = numberOfImages/numberOfImagesInPage;
	if(numberOfImages%numberOfImagesInPage != 0) {
		numberOfPages++;
	}
	
	self.contentSize = CGSizeMake(numberOfPages*bounds.size.width, bounds.size.height);
}

-(void) layoutSubviews {
	[super layoutSubviews];
	[self computeLayoutGeometry];
	[self baseInit];
}

-(int) numberOfPages {
	return numberOfPages;
}

-(void)thumbImageTag:(int)tag {
	[viewDelegate selectedBook:tag];
}

-(void) showCloseIcons {
	for(int i = 0; i < [imageArray count]; i++) {
		ThumbImageView* imgView = [imageArray objectAtIndex:i];
		[imgView showCloseIcon];
	}
}

-(void) doneShowCloseIcons {
	for(int i = 0; i < [imageArray count]; i++) {
		ThumbImageView* imgView = [imageArray objectAtIndex:i];
		[imgView removeCloseIcon];
	}
}

- (void)close:(int)tag {
	ThumbImageView *imgView = [imageArray objectAtIndex:tag];
	[imgView removeFromSuperview];
	[imageArray removeObjectAtIndex:tag];
	numberOfImages--;
	[dataSource removeElement:tag];
	[self setNeedsLayout];
	
	for(int i = 0; i < [imageArray count]; i++) {
		//Reset image tags to compensate for deleted image
		ThumbImageView *vw = [imageArray objectAtIndex:i];
		vw.tag = i;
	}
}


- (void) dealloc {
	[imageArray release];
	[super dealloc];
}

@end

 

