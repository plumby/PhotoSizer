//
//  PSImageViewController.h
//  PhotoSizer
//
//  Created by Ian on 05/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>



@interface PSAssetViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIImageView* imageView;
    IBOutlet UIView* assetView;
    IBOutlet UIScrollView* scrollView;
    MPMoviePlayerController* theMovie;
    BOOL isShowingLandscapeView;

}

@property (strong, nonatomic) ALAsset* asset;



@end
