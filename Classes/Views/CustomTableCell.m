//
//  CustomTableCell.m
//  AudioBookLibrary
//
//  Created by Vivek Nagar on 8/11/10.
//  Copyright Vivek Nagar 2010. All rights reserved.
//


#import "CustomTableCell.h"

@implementation CustomTableCell


- (void)dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    
    if (self == nil)
    { 
        return nil;
    }
    
	self.backgroundColor = [UIColor blackColor];
	self.textLabel.textColor = [UIColor whiteColor];

    return self;
}


@end
