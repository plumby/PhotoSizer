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
    IBOutlet UIImageView *_photoImageView;
    IBOutlet UILabel* _sizeLabel;
}

@property UIImageView *_photoImageView;
@property UILabel* _sizeLabel;

@end
