//
//  PSAssetDetailViewController.h
//  PhotoSizer
//
//  Created by Ian on 18/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PSAssetLoader.h"


@interface PSAssetDetailViewController : UIViewController
{
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *sizeLabel;
    IBOutlet UILabel *dimensionLabel;
    IBOutlet UITextView *generalTextField;
    IBOutlet MKMapView* _mapView;
};

- (void)setAsset:(ALAsset*)newDetailItem;

@property (strong, nonatomic) ALAsset* asset;



@end
