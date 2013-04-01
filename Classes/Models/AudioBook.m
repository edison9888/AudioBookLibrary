//
//  AudioBook.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/7/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import "AudioBook.h"


@implementation AudioBook

@synthesize title, author, description, desc, ArchiveOrgURL, GutenburgURL, bookid;
@synthesize zipfile, WikiBookURL, AuthorURL, ForumURL, OtherURL, Category, Genre, NumberOfSections;
@synthesize reader, rssurl, url, image;

- (void)dealloc 
{
	[title release];
	[author release];
	[description release];
	[desc release];
	[ArchiveOrgURL release];
	[GutenburgURL release];
	[bookid	release];
	[zipfile release];
	[WikiBookURL release];
	[AuthorURL release];
	[ForumURL release];
	[OtherURL release];
	[Category release];
	[Genre release];
	[NumberOfSections release];
	[reader release];
	[rssurl release];
	[url release];
	[image release];
    [super dealloc];
}


@end
