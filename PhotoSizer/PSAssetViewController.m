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


-(void)configureViewForImage
{
    
        // asset is an image
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=assetView.frame;
    [assetView addSubview:scrollView];
    
    imageView=[[UIImageView alloc]initWithFrame:assetView.bounds];
    
    
    
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGFloat scale  = 1;
    UIImageOrientation orientation = UIImageOrientationUp;
    
    UIImage *image = [UIImage imageWithCGImage:[rep fullScreenImage] scale:scale orientation:orientation];
    float minXScale=scrollView.bounds.size.width/image.size.width;
    float minYScale=scrollView.bounds.size.height/image.size.height;
    
    float minScale=MIN(minXScale, minYScale);
    float screenScale=MAX(minXScale, minYScale);
    
    imageView.image=image;//[PSAssetViewController imageWithImage:image scaledToMaxWidth:imageView.bounds.size.width maxHeight:imageView.bounds.size.height];
    imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    scrollView.contentSize = image.size;
    
    scrollView.minimumZoomScale=minScale;
    scrollView.maximumZoomScale=screenScale;//10.0;
    scrollView.delegate=self;
    
    scrollView.zoomScale=minScale;
    
    [scrollView addSubview:imageView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.contentInset = UIEdgeInsetsZero;
        //[scrollView ensureContentIsCentered];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:doubleTapRecognizer];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centreImageView];
}

-(void)viewDidLayoutSubviews
{
    [self centreImageView];
    
}

- (void)centreImageView
{
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetX = MAX(0, (bounds.size.width - contentSize.width) * 0.5f);
    CGFloat offsetY = MAX(0, (bounds.size.height - contentSize.height) * 0.5f);
    
    imageView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
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
            [self configureViewForImage];
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


-(void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    if (scrollView.zoomScale==scrollView.minimumZoomScale)
    {
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
            //        scrollView.zoomScale=scrollView.maximumZoomScale;
    }
    else
    {
        [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
    }
}


-(void)scrollViewDoubleTapped2:(UITapGestureRecognizer*)recognizer {
        // 1
    CGPoint pointInView = [recognizer locationInView:imageView];
    
        // 2
    CGFloat newZoomScale = scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, scrollView.maximumZoomScale);
    
        // 3
    CGSize scrollViewSize = scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
        // 4
    [scrollView zoomToRect:rectToZoomTo animated:YES];
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
