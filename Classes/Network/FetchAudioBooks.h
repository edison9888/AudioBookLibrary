//
//  FetchAudioBooks.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/7/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

@protocol FetchBooksDelegate;

#import <Foundation/Foundation.h>
#import "AudioBook.h"
#import "HTTPConnection.h"

@interface FetchAudioBooks : NSObject <HTTPConnectionDelegate, NSXMLParserDelegate> 
{
    HTTPConnection *connection;
	NSMutableString *currentElementValue;
	NSMutableArray *books;
	AudioBook *aBook;
}

@property (nonatomic, retain) id<FetchBooksDelegate> delegate;

-(void)getBooks:(NSString*)URL;

@end

@protocol FetchBooksDelegate<NSObject>
- (void)finishedLoadingBooks:(NSMutableArray*)books;
@end

