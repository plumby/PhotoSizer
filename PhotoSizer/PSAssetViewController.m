//
//  PSImageViewController.m
//  PhotoSizer
//
//  Created by Ian on 05/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "PSAssetViewController.h"

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
            
            [assetView addSubview:imageView];
            [imageView sizeToFit ];
        }
    }
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
    
    /*
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(MPMoviePlayerLoadStateDidChangeNotification:) name:MPMoviePlayerLoadStateDidChangeNotification
        object:theMovie];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMovieDurationAvailableNotification:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMovieMediaTypesAvailableNotification:)
                                                 name:MPMovieMediaTypesAvailableNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMovieNaturalSizeAvailableNotification:)
                                                 name:MPMovieNaturalSizeAvailableNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerContentPreloadDidFinishNotification:)
                                                 name:MPMoviePlayerContentPreloadDidFinishNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerNowPlayingMovieDidChangeNotification:)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChangeNotification:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMovieSourceTypeAvailableNotification:)
                                                 name:MPMovieSourceTypeAvailableNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerReadyForDisplayDidChangeNotification:)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:theMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerThumbnailImageRequestDidFinishNotification:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:theMovie];
    
    */
    
    [theMovie prepareToPlay];
    
        // Movie playback is asynchronous, so this method returns immediately.
    [theMovie play];
    
    
    NSArray* events=theMovie.errorLog.events;
    
    for (MPMovieErrorLogEvent* event in events)
    {
        NSLog(@"%@ - %@",event.playbackSessionID,event.errorComment);
    }
    
}


-(void)MPMovieDurationAvailableNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMovieMediaTypesAvailableNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMovieNaturalSizeAvailableNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerContentPreloadDidFinishNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerDidEnterFullscreenNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerDidExitFullscreenNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerLoadStateDidChangeNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerNowPlayingMovieDidChangeNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerPlaybackStateDidChangeNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerThumbnailImageRequestDidFinishNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMovieSourceTypeAvailableNotification:(NSNotification*)aNotification
{
     NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}
-(void)MPMoviePlayerReadyForDisplayDidChangeNotification:(NSNotification*)aNotification
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
}


    // When the movie is done,release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
        //MPMoviePlayerController* theMovie2=[aNotification object];
    
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie2];
    
        //theMovie2.view.frame = CGRectMake(0, 0, 0, 0);
        // Release the movie instance created in playMovieAtURL
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
