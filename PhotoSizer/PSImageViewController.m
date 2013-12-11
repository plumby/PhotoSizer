//
//  PSImageViewController.m
//  PhotoSizer
//
//  Created by Ian on 05/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "PSImageViewController.h"

@interface PSImageViewController ()

@end

@implementation PSImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setAsset:(ALAsset*)newDetailItem
{
    if (_asset != newDetailItem) {
        _asset = newDetailItem;
        
            // Update the view.
            [self configureView];
    }
}


- (void)configureView
{
        // Update the user interface for the detail item.
    
    if (self.asset)
    {
        ALAssetRepresentation *rep = [self.asset defaultRepresentation];
        CGFloat scale  = 1;
        UIImageOrientation orientation = UIImageOrientationUp;
        
        /*
        NSNumber* orientationValue = [[rep metadata] objectForKey:@"Orientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
         */
        
        UIImage *image = [UIImage imageWithCGImage:[rep fullScreenImage] scale:scale orientation:orientation];
        imageView.image=image;
        
        /*
        ALAssetRepresentation *assetRepresentation = [self.detailItem defaultRepresentation];
        CGImageRef fullResImage = [assetRepresentation fullScreenImage];
        
        imageView.image=[UIImage imageWithCGImage:fullResImage];
        */
            //[[self.detailItem defaultRepresentation] fullScreenImage];
            //self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
