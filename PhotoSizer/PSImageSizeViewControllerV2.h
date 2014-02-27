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

@interface PSImageSizeViewControllerV2 : UIViewController <ADBannerViewDelegate> 
{
        //BOOL includeVideo;
        //BOOL includePhotos;
    
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl* segmentControl;
    PSAlbumData* _album;
    PSAssetLoader* _loader;
        //NSArray* assets;
    
    UIActivityIndicatorView *activityIndicator;
    IBOutlet ADBannerView* _adBannerView;
    BOOL isBannerVisible;
    UIActivityIndicatorView *_activityIndicator;
    
}

@property (nonatomic, retain) id adBannerView;




    //-(void)setAlbum:(PSAlbumData*) newAlbum;
-(void)setLoader:(PSAssetLoader*)loader;


    //@property(nonatomic, strong) NSArray *assets;

- (IBAction)segmentSwitch:(id)sender;

@end
