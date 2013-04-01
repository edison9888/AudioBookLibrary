//
//  ThumbImageView.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import "ThumbImageView.h"


@interface ThumbImageView ()
-(void) baseInit;
@end;

@implementation ThumbImageView
@synthesize delegate;
@synthesize imageName;
@synthesize imageView;
@synthesize labelView;
@synthesize closeView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
	CGRect bounds = [self bounds];
	
	float x = 10.0;
	float y = 0.0;
	float IMAGE_HEIGHT = bounds.size.height - 50.0;
	
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, bounds.size.width, IMAGE_HEIGHT)];
	[self addSubview:imageView];
	
	y = y + IMAGE_HEIGHT;
	labelView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, bounds.size.width, 50)];
	labelView.backgroundColor = [UIColor clearColor];
	labelView.font = [UIFont boldSystemFontOfSize:12];
	labelView.textColor = [UIColor blackColor];
	labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 3;
	[self addSubview:labelView];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	UIView *touchedView = [touch view];
	if(touchedView == closeView) {
		// NSLog(@"View touched:%@", [touch view]);
		[delegate close:[self tag]];

	} else {
	
		if ([delegate respondsToSelector:@selector(thumbImageTag:)])
			[delegate thumbImageTag:[self tag]];
	}
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


-(void) showCloseIcon {
	UIImage *closeImg = [UIImage imageNamed:@"close-icon.png"];
	closeView = [[UIImageView alloc] initWithImage:closeImg];
	closeView.frame = CGRectMake(0, 0, 30, 30);
	[closeView setUserInteractionEnabled:YES];
	[self addSubview:closeView];
}

-(void) removeCloseIcon {
	[closeView removeFromSuperview];
}

- (void) dealloc {
	[closeView release];
	[imageView release];
	[labelView release];
	
	[super dealloc];
}

@end

 

