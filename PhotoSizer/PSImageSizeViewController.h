//
//  PSImageSizeViewController.h
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAlbumData.h"

@interface PSImageSizeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    IBOutlet UIBarButtonItem* sortButton;
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl* segmentControl;
    BOOL includeVideo;
    BOOL includePhotos;
}

@property(nonatomic, strong) NSArray *assets;

- (IBAction)segmentSwitch:(id)sender;

- (IBAction) sort;

-(void)setAlbum:(PSAlbumData*) newAlbum;



@end
