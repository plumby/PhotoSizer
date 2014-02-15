//
//  PSImageSizeViewControllerV2.h
//  PhotoSizer
//
//  Created by Ian on 19/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PSAlbumData.h"


@interface PSImageSizeViewControllerV2 : UIViewController
{
    BOOL includeVideo;
    BOOL includePhotos;
    
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl* segmentControl;
    PSAlbumData* album;
        //NSArray* assets;
    
    UIActivityIndicatorView *activityIndicator;
    
}




-(void)setAlbum:(PSAlbumData*) newAlbum;


    //@property(nonatomic, strong) NSArray *assets;

- (IBAction)segmentSwitch:(id)sender;

@end
