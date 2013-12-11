//
//  PSImageViewController.h
//  PhotoSizer
//
//  Created by Ian on 05/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PSImageViewController : UIViewController
{
    IBOutlet UIImageView* imageView;
}

@property (strong, nonatomic) ALAsset* asset;



@end
