//
//  FetchAudioBooks.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/7/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import "FetchAudioBooks.h"


@implementation FetchAudioBooks

@synthesize delegate;

- (id) init
{
	self = [super init];
	connection = [[HTTPConnection alloc] init];
	connection.delegate = self;
	
	return self;
}

//
// dealloc
- (void)dealloc
{
	[connection release];
	[super dealloc];
}


-(void)getBooks:(NSString*)URL 
{
	[connection get:URL];
}

- (void)HTTPConnectionDidFailWithError:(NSError*)error 
{
	NSLog(@"Error:%@", [error localizedDescription]);
}

- (void)HTTPConnectionDidFinishLoading:(NSString*)content 
{
	// NSLog(@"Returned content:%@", content);
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[content dataUsingEncoding: NSUTF8StringEncoding]];
		
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
	
    BOOL success = [parser parse]; // Parse that data..
	
    if (!success) {
		NSLog(@"Error parsing XML data from source:%@", [[parser parserError]localizedDescription]);
    }
	
    [parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict 
{
	if([elementName isEqualToString:@"results"]) 
	{
		//Initialize the array.
		books = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"book"]) 
	{
		
		//Initialize the book.
		aBook = [[AudioBook alloc] init];
		
		//Extract the attribute here.
		// aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
	}
	
	// NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	// NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if([elementName isEqualToString:@"results"]) {
		[delegate finishedLoadingBooks:books];
		return;
	}
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"book"]) 
	{
		[books addObject:aBook];
		[aBook release];
		aBook = nil;
	} else if([elementName isEqualToString:@"id"]) 
	{
		[aBook setValue:currentElementValue forKey:@"bookid"];
	} else if([elementName isEqualToString:@"description"]) 
	{
		[aBook setValue:currentElementValue forKey:elementName];
		[aBook setValue:currentElementValue forKey:@"desc"];
	}
	else 
	{
		[aBook setValue:currentElementValue forKey:elementName];
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}

@end
