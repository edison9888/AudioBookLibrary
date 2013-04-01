//
//  SavedAudioBook.h
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/21/10.
//  Copyright 2010 Vivek Nagar. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface SavedAudioBook :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * OtherURL;
@property (nonatomic, retain) NSString * Genre;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * bookid;
@property (nonatomic, retain) NSString * zipfile;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * WikiBookURL;
@property (nonatomic, retain) NSString * ForumURL;
@property (nonatomic, retain) NSString * NumberOfSections;
@property (nonatomic, retain) NSString * ArchiveOrgURL;
@property (nonatomic, retain) NSString * reader;
@property (nonatomic, retain) NSString * rssurl;
@property (nonatomic, retain) NSString * GutenburgURL;
@property (nonatomic, retain) NSString * Category;
@property (nonatomic, retain) NSString * AuthorURL;

@end



