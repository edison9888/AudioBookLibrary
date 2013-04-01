
//
//  ThumbImageView.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//

@protocol ThumbImageViewDelegate;


@interface ThumbImageView : UIView {
    id <ThumbImageViewDelegate> delegate;
	UIImageView *imageView;
	UILabel *labelView;
	UIImageView *closeView;
}

-(void) showCloseIcon;
-(void) removeCloseIcon;

@property (nonatomic, assign) id <ThumbImageViewDelegate> delegate;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *closeView;
@property (nonatomic, retain) UILabel *labelView;

@end

@protocol ThumbImageViewDelegate <NSObject>
@optional
- (void)thumbImageTag:(int)tag;
- (void)close:(int)tag;
@end

