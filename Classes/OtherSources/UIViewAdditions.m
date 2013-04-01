//
//  UIViewAdditions.m
//  AudioBooks
//
//  Created by Vivek Nagar on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@implementation UIView (debug)

- (void)printSubviewsOfView {
    static NSInteger depthCount = 0;
	
    NSArray *subview_array = [self subviews];
	
    NSMutableString *tabString = [NSMutableString 
								  stringWithCapacity:depthCount];
    for (NSInteger i = 0; i < depthCount; i++) {
        [tabString appendString:@" -- "];
    }
    NSLog(@"%@ %@",tabString,self);
	
    if (subview_array) {
        depthCount++;
        for(UIView *v in subview_array) {
            [v printSubviewsOfView];
        }
        depthCount--;
    }
}



@end