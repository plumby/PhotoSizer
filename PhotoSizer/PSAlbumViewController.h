//
//  PSAlbumViewController.h
//  PhotoSizer
//
//  Created by Ian on 15/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAlbumViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    NSArray * assets;
}


@end
