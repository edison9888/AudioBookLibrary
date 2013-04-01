//
//  AudioControlView.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
 
@class AudioControlView;
 
@protocol AudioControlDelegate
-(void) stop;
-(void) play;
-(void) pause;
-(void) addBookmark;
-(void) forward:(int) seekValue;
@end
 
@interface AudioControlView : UIView {
	UIToolbar *buttonBar;
	UIButton *playPauseButton;
	UIButton *stopButton;
	UIButton *forwardButton;
	UILabel *positionLabel;
	UISlider *musicControl;	

    id <AudioControlDelegate> delegate;
	BOOL toolbarHidden;
}

@property (nonatomic, retain) UIToolbar *buttonBar;
@property (nonatomic, retain) UISlider *musicControl;
@property (nonatomic, retain) UILabel *positionLabel;
@property (nonatomic, retain) UIButton *playPauseButton;
@property (nonatomic, retain) UIButton *stopButton;
@property (nonatomic, retain) UIButton *forwardButton;

@property (nonatomic, retain) id <AudioControlDelegate> delegate;

-(void) updateSlider:(double)progress duration:(double)duration;
-(void) reset;
 
@end

