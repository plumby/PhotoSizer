//
//  PSImageSizeCell.h
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSImageSizeCell : UITableViewCell
{
    IBOutlet UIImageView *photoImageView;
    IBOutlet UILabel* sizeLabel;
}

@property UIImageView *photoImageView;
@property UILabel* sizeLabel;

@end
