//
//  PSImageSizeViewControllerV2.m
//  PhotoSizer
//
//  Created by Ian on 19/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSImageSizeViewControllerV2.h"
#import "PSImageSizeCell.h"
#import "PSImageData.h"
#import "PSAssetViewController.h"

@interface PSImageSizeViewControllerV2 ()

@end

@implementation PSImageSizeViewControllerV2

@synthesize adBannerView= _adBannerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_loader.isExecuting)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        activityIndicator.center = tableView.center;
        
        [tableView addSubview:activityIndicator];
        [activityIndicator setHidden:FALSE];
        [activityIndicator setHidesWhenStopped:FALSE];
        
        [activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
        
        
        __block PSImageSizeViewControllerV2* tempSelf=self;
        
        [_loader setCompletionBlock:^(void)
        {
            [tempSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:YES];
        }];
    }
    
    
            //[_loader waitUntilFinished];
    
   [tableView reloadData];
    segmentControl.selectedSegmentIndex=2;
    
    
    
        //    CGRect screenSize=[_adBannerView.]
        //    _adBannerView setPosition:
    
	// Do any additional setup after loading the view.
}

- (void) refreshTableView
{
    [tableView reloadData];
    [self.view setUserInteractionEnabled:TRUE];
    [activityIndicator setHidesWhenStopped:TRUE];
    
    [activityIndicator stopAnimating];

}



-(void)viewDidNotLayoutSubviews
{
    CGRect zero=CGRectMake(160, 503, _adBannerView.frame.size.width, _adBannerView.frame.size.height);
    
        //_adBannerView.frame;//CGRectMake(0, 0, _adBannerView.frame.size.width, _adBannerView.frame.size.height);
    
    _adBannerView.frame = CGRectOffset(zero, 0, 50);
    isBannerVisible=NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    //-(void)setAlbum:(PSAlbumData*) newAlbum
    //{
    //_album=newAlbum;
    //}


-(void)setLoader:(PSAssetLoader *)loader
{
    _loader=loader;
    _album=loader.album;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of sections.
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    if(_album.includePhotos && _album.includeVideo)
    {
        return 2;
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0 && _album.includeVideo)
    {
        return @"Videos";
    }
    else
    {
        return @"Photos";
    }
        //return @"XX";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of rows in the section.
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
        //return [assets count];
        //    return [self.album.assets count]
    if (section==0 && _album.includeVideo)
    {
        return [_album.videos count];
    }
    else
    {
            return [_album.photos count];
    }
}




- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PSImageSizeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //    PSImageData* imgData=album.assets[indexPath.row];
    PSImageData* imgData;
    
    if (indexPath.section==0 && _album.includeVideo)
    {
        imgData=_album.videos[indexPath.row];
    }
    else
    {
        imgData=_album.photos[indexPath.row];
    }
    
    ALAsset *asset =imgData.assett;
        //UIImage *image=[UIImage imageWithCGImage:[asset thumbnail]];
        //    NSURL* s=[asset valueForProperty:ALAssetPropertyAssetURL];
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensure the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
        //NSString *formattedNumberString = [NSString stringWithFormat:@"%lli",assetRepresentation.size];
    
    NSNumber* size=[[NSNumber alloc]initWithLongLong:assetRepresentation.size/1024];
        //NSLog(@"formattedNumberString: %@", formattedNumberString);
        // Output for locale en_US: "formattedNumberString: formattedNumberString: 122,344.453"
    
    cell.sizeLabel.text=[NSString stringWithFormat:@"%@ KB",[numberFormatter stringForObjectValue:size]];
    
        //    cell.sizeLabel.text=[NSString stringWithFormat:@"%lli",assetRepresentation.size];
    cell.photoImageView.image=[UIImage imageWithCGImage:[asset thumbnail]];
    
        //[s absoluteString];
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return cell;
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        _album.includePhotos=YES;
        _album.includeVideo=NO;
    }
    else if (selectedSegment == 1)
    {
        _album.includePhotos=NO;
        _album.includeVideo=YES;
    }
    else
    {
        _album.includePhotos=YES;
        _album.includeVideo=YES;
    }
    [tableView reloadData];
        //[self loadAssets];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSImageData* imgData;
        
        if (indexPath.section==0 && _album.includeVideo)
        {
            imgData=_album.videos[indexPath.row];
        }
        else
        {
            imgData=_album.photos[indexPath.row];
        }
        
        ALAsset *asset =imgData.assett;
        [[segue destinationViewController] setAsset:asset];
    }
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
        //if (!isBannerVisible)
        //{
        //[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
            // banner is invisible now and moved out of the screen on 50 px
        //banner.frame = CGRectOffset(banner.frame, 0, -50);
        //[UIView commitAnimations];
        //isBannerVisible = YES;
        //}
    
        //    if (!_adBannerViewIsVisible) {
        //_adBannerViewIsVisible = YES;
        //[self fixupAdView:[UIDevice currentDevice].orientation];
        //}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
        //if (isBannerVisible)
        //{
        //[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
            // banner is visible and we move it out of the screen, due to connection issue
        //banner.frame = CGRectOffset(banner.frame, 0, 50);
        //[UIView commitAnimations];
        //isBannerVisible = NO;
        //}
}




@end
