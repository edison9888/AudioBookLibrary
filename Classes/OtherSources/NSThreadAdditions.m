//
//  NSThreadAdditions.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/7/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <execinfo.h>

@implementation NSThread (debug)

+ (void)printStackTrace 
{
	void* callstack[128]; 
	int i, frames;
	frames = backtrace(callstack, 128); 
	char** strs = backtrace_symbols(callstack, frames); 
	for (i = 0; i < frames; ++i) { 
		printf("%s\n", strs[i]); 
	} 
	free(strs);
}



@end
