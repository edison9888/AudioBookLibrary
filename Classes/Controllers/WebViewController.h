//
//  WebViewController.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/8/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> 
{
	UIWebView *webView;
	NSString* urlAddress;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString* urlAddress;

-(WebViewController*) initWithURLString:(NSString*)urlString;

@end
