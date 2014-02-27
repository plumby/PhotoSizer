//
//  PSImageViewController.m
//  PhotoSizer
//
//  Created by Ian on 05/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "PSAssetViewController.h"
#import "PSAssetDetailViewController.h"

@interface PSAssetViewController ()

@end

@implementation PSAssetViewController

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
            //[self configureView];
    }
}


- (void)configureView
{
    if (self.asset)
    {
        if ([[self.asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])
        {
                // asset is a video
            ALAssetRepresentation *rep = [self.asset defaultRepresentation];
            [self playMovieAtURL:[rep url]];
        }
        else
        {
                // asset is an image
            
            imageView=[[UIImageView alloc]initWithFrame:assetView.bounds];
            
            
            
            ALAssetRepresentation *rep = [self.asset defaultRepresentation];
            CGFloat scale  = 1;
            UIImageOrientation orientation = UIImageOrientationUp;
            
            UIImage *image = [UIImage imageWithCGImage:[rep fullScreenImage] scale:scale orientation:orientation];
            
            imageView.image=[PSAssetViewController imageWithImage:image scaledToMaxWidth:imageView.bounds.size.width maxHeight:imageView.bounds.size.height];
            scrollView.minimumZoomScale=0.5;
            scrollView.maximumZoomScale=6.0;
            scrollView.contentSize=assetView.bounds.size;//image.size;//CGSizeMake(1280, 960);
            scrollView.delegate=self;
            
                //            scrollView.ma
            
            [scrollView addSubview:imageView];
            [imageView sizeToFit ];
            assetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)awakeFromNib
{
    isShowingLandscapeView = NO;
        //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        //[[NSNotificationCenter defaultCenter] addObserver:self
        //                                   selector:@selector(orientationChanged:)
        //                                         name:UIDeviceOrientationDidChangeNotification
        //                                       object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
        //assetView.bounds=CGRectMake(0, 0, assetView.bounds.size.height, assetView.bounds.size.width);
    
        //CGSizeMake(tempSize.height, tempSize.width);
    
    /*
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView)
    {
        [self performSegueWithIdentifier:@"DisplayAlternateView" sender:self];
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }
     */
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
        //CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    CGFloat widthScale=width / oldWidth;
    CGFloat heightScale=height / oldHeight;
    
    CGFloat scaleFactor = MIN(widthScale, heightScale);
    
        //    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

            



-(void)playMovieAtURL:(NSURL*)theURL

{
    theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL];
    theMovie.scalingMode=MPMovieScalingModeNone;
        //    theMovie.controlStyle=MPMovieControlStyleNone;
    
    [theMovie setFullscreen:NO animated:YES];
    theMovie.controlStyle = MPMovieControlStyleEmbedded;
    
    theMovie.view.frame = assetView.frame;//CGRectMake(2, 100, 217, 270);
    [assetView addSubview:theMovie.view];
    
        // Register for the playback finished notification.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];
    

    [theMovie prepareToPlay];
    
        // Movie playback is asynchronous, so this method returns immediately.
    [theMovie play];
    
    
    NSArray* events=theMovie.errorLog.events;
    
    for (MPMovieErrorLogEvent* event in events)
    {
        NSLog(@"%@ - %@",event.playbackSessionID,event.errorComment);
    }
    
}



- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center
{
    return CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

    // When the movie is done,release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ViewAssetDetail"])
    {
        [[segue destinationViewController] setAsset:_asset];
    }
}


@end
