//
//  PSImageSizeCell.m
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "PSImageSizeCell.h"

@implementation PSImageSizeCell

@synthesize _photoImageView,_sizeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
