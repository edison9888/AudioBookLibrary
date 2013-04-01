
//
//  ActivityView.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import "ActivityView.h"
 
@implementation ActivityView
 
@synthesize activityView;
 
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		self.activityView.backgroundColor = [UIColor blackColor];
        [self addSubview:activityView];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [activityView startAnimating];
    }
     
    return self;
}
 
- (void) close
{
	[activityView stopAnimating];
	activityView.hidden = YES;
}
 
- (void) dealloc
{
    [activityView release];
    [super dealloc];
}
 
@end

