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
#import "iAd/ADBannerView.h"

#import "PSAssetLoader.h"

@interface PSImageSizeViewController : UIViewController <ADBannerViewDelegate> 
{
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl* segmentControl;
    PSAlbumData* _album;
    PSAssetLoader* _loader;
    
    UIActivityIndicatorView *activityIndicator;
    IBOutlet ADBannerView* _adBannerView;
    BOOL isBannerVisible;
    UIActivityIndicatorView *_activityIndicator;
    
}

@property (nonatomic, retain) id adBannerView;

-(void)setLoader:(PSAssetLoader*)loader;

- (IBAction)segmentSwitch:(id)sender;

@end
