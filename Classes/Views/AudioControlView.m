//
//  AudioControlView.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import "AudioControlView.h"
 
@implementation AudioControlView

@synthesize delegate;
@synthesize buttonBar;
@synthesize musicControl;
@synthesize playPauseButton, stopButton, forwardButton;
@synthesize positionLabel;
 
#pragma mark Main
- (void)baseInit {
	self.autoresizesSubviews = YES;
    self.backgroundColor = [UIColor clearColor];
	CGRect bounds = [self bounds];
	NSLog(@"Bound:%f and %f", bounds.size.width, bounds.size.height);
	
	float width = bounds.size.width;
	float BUTTONBAR_HEIGHT = 40.0;
	float y = 0.0;
	
	buttonBar = [UIToolbar new];
	buttonBar.barStyle = UIBarStyleBlack;
	buttonBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	buttonBar.translucent = YES;
	[buttonBar sizeToFit];
	buttonBar.frame = CGRectMake(0, y, width, BUTTONBAR_HEIGHT);
	
	//Add buttons
	UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																				 target:self
																				 action:@selector(addBookmark:)];
	
	//Add buttons to the array
	NSArray *items = [NSArray arrayWithObjects:bookmarkButton, nil];
	[bookmarkButton release];
	[buttonBar setItems:items animated:NO];
	[self addSubview:buttonBar];
	buttonBar.alpha = 0;
	toolbarHidden = YES;
	
	y = BUTTONBAR_HEIGHT;
	float button_height = 75.0;
	float button_width = 75.0;
	float offset = 10.0;
	float initialX = (width - (3*button_width + 2*offset))/2;
	
	stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	stopButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	stopButton.frame = CGRectMake(initialX, y, button_width, button_height);
	UIImage *stopImg = [UIImage imageNamed:@"stop.png"];
	[stopButton setBackgroundImage:stopImg forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stopClick:)
		 forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:stopButton];
	
	playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playPauseButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	playPauseButton.frame = CGRectMake(initialX+button_width+offset, y, button_width, button_height);
	playPauseButton.backgroundColor = [UIColor clearColor];
	UIImage *playImg = [UIImage imageNamed:@"play.png"];
	[playPauseButton setBackgroundImage:playImg forState:UIControlStateNormal];
	UIImage *pauseImg = [UIImage imageNamed:@"pause.png"];
	[playPauseButton setBackgroundImage:pauseImg forState:UIControlStateSelected];
	[playPauseButton addTarget:self action:@selector(playPauseClick:)
			  forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:playPauseButton];
	
	forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	forwardButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	forwardButton.frame = CGRectMake(initialX+2*button_width+2*offset, y, button_width, button_height);
	forwardButton.backgroundColor = [UIColor clearColor];
	UIImage *skipImg = [UIImage imageNamed:@"forward.png"];
	[forwardButton setBackgroundImage:skipImg forState:UIControlStateNormal];
	[forwardButton addTarget:self action:@selector(forwardClick:)
			forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:forwardButton];
	
	float SLIDER_WIDTH = 300.0;
	float SLIDER_HEIGHT = 40.0;
	y = y + button_height;
	initialX = (bounds.size.width - SLIDER_WIDTH)/2;
	
	musicControl = [[UISlider alloc] initWithFrame:CGRectMake(initialX, y, SLIDER_WIDTH, SLIDER_HEIGHT)];
	musicControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	musicControl.minimumValue = 0.0;
	musicControl.maximumValue = 100.0;
	musicControl.tag = 0;
	musicControl.value = 0.0;
	musicControl.continuous = YES;
    
	[musicControl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:musicControl ];
	
	initialX = initialX + 10.0;
	y = y + SLIDER_HEIGHT;
	positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(initialX, y, 250.0, SLIDER_HEIGHT)];
	positionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	positionLabel.textColor = [UIColor blackColor];
	NSString *newText =[[NSString alloc] initWithFormat:@"Time Played: %.1f/%.1f seconds",0.0, 0.0];
	positionLabel.text = newText;
	[newText release];
	positionLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:positionLabel];
	
}
 
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
    }
    return self;
}
 
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];        
    }
    return self;
}
 
- (void)dealloc {
	[buttonBar release];
	[playPauseButton release];
	[forwardButton release];
	[stopButton release];
	[musicControl release];
	[positionLabel release];
    [super dealloc];
}


- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect bounds = [self bounds];
	
	float width = bounds.size.width;
	float BUTTONBAR_HEIGHT = 40.0;
	float y = 0.0;
	
	buttonBar.frame = CGRectMake(0, y, width, BUTTONBAR_HEIGHT);
	
	y = BUTTONBAR_HEIGHT;
	float button_height = 75.0;
	float button_width = 75.0;
	float offset = 10.0;
	float initialX = (width - (3*button_width + 2*offset))/2;
	
	stopButton.frame = CGRectMake(initialX, y, button_width, button_height);
	
	playPauseButton.frame = CGRectMake(initialX+button_width+offset, y, button_width, button_height);
	
	forwardButton.frame = CGRectMake(initialX+2*button_width+2*offset, y, button_width, button_height);
	
	float SLIDER_WIDTH = 300.0;
	float SLIDER_HEIGHT = 40.0;
	y = y + button_height;
	initialX = (bounds.size.width - SLIDER_WIDTH)/2;
	
	musicControl.frame = CGRectMake(initialX, y, SLIDER_WIDTH, SLIDER_HEIGHT);
	
    	
	initialX = initialX + 10.0;
	y = y + SLIDER_HEIGHT;
	positionLabel.frame = CGRectMake(initialX, y, 250.0, SLIDER_HEIGHT);	
}

 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	if(toolbarHidden)
	{
		[UIView beginAnimations:@"toolbar" context:nil];
		[UIView setAnimationDuration:1.5];
	
		buttonBar.frame = CGRectOffset(buttonBar.frame, 0, 0);
		buttonBar.alpha = 1;
		toolbarHidden = NO;
	
		[UIView commitAnimations];
	}
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(fadeToolBar:)
								   userInfo:nil
									repeats:NO];	
}

-(void) fadeToolBar:(NSTimer*)theTimer
{
	if(!toolbarHidden)
	{
		[UIView beginAnimations:@"toolbar" context:nil];
		[UIView setAnimationDuration:1.5];
		
		buttonBar.frame = CGRectOffset(buttonBar.frame, 0, 0);
		buttonBar.alpha = 0;
		toolbarHidden = YES;
		
		[UIView commitAnimations];
	}
	
}

-(void) reset 
{
	playPauseButton.selected = YES;
	musicControl.value = 0;
}

-(void) stopClick:(id)sender
{
	if(playPauseButton.selected)
	{
		playPauseButton.selected = !playPauseButton.selected;
	}
	// call delegate stop
	[delegate stop];
}

-(void) forwardClick:(id)sender
{
	// call delegate forward
	[delegate forward:0];
}

-(void) playPauseClick:(id) sender
{
	UIButton *button = (UIButton *) sender;
	if(!button.selected) {
		// call delegate start
		[delegate play];
	} else {
		// call delegate pause
		[delegate pause];
	}
	button.selected = !button.selected;
}

- (IBAction)sliderAction:(UISlider *)sender {
	// call delegate forward with value (musicControl.value)	
	[delegate forward:musicControl.value];
}

- (void)updateSlider:(double) progress duration:(double)duration {
    // Update the slider about the music time
    musicControl.value = progress;
	if (duration > 0) {
		[positionLabel setText:
			 [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
			  progress,
			  duration]];
			
		[musicControl setEnabled:YES];
		[musicControl setValue:100 * progress / duration];
	}
	else
	{
		[positionLabel setText:
		 [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
		  0.0,
		  0.0]];
		
		[musicControl setEnabled:YES];
		[musicControl setValue:0.0];
    }
	
}

-(void) addBookmark:(id)sender
{
	[delegate addBookmark];
}


@end