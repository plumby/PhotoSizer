//
//  PSAlbumViewController.h
//  PhotoSizer
//
//  Created by Ian on 15/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAlbumLoader.h"

@interface PSAlbumViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    NSArray * _albums;
    PSAlbumLoader* _albumLoader;
    UIActivityIndicatorView *_activityIndicator;
}


@end
