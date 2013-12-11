//
//  PSImageSizeViewController.h
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSImageSizeViewController : UITableViewController
{
    IBOutlet UIActivityIndicatorView *activityView;
}

@property(nonatomic, strong) NSArray *assets;

- (IBAction) sort;


@end
