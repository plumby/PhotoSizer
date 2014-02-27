//
//  PSImageSizeViewControllerV2.m
//  PhotoSizer
//
//  Created by Ian on 19/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSImageSizeViewController.h"
#import "PSImageSizeCell.h"
#import "PSImageData.h"
#import "PSAssetViewController.h"

@interface PSImageSizeViewController ()

@end

@implementation PSImageSizeViewController

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
    
    [tableView reloadData];
    segmentControl.selectedSegmentIndex=2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLoader:(PSAssetLoader *)loader
{
    _loader=loader;
    _album=loader.album;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    PSImageData* imgData;
    
    if (indexPath.section==0 && _album.includeVideo)
    {
        imgData=_album.videos[indexPath.row];
    }
    else
    {
        imgData=_album.photos[indexPath.row];
    }
    
    ALAsset *asset =imgData.asset;
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensure the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    
    NSNumber* size=[[NSNumber alloc]initWithLongLong:assetRepresentation.size/1024];
    
    cell._sizeLabel.text=[NSString stringWithFormat:@"%@ KB",[numberFormatter stringForObjectValue:size]];
    
    cell._photoImageView.image=[UIImage imageWithCGImage:[asset thumbnail]];
    
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
        
        ALAsset *asset =imgData.asset;
        [[segue destinationViewController] setAsset:asset];
    }
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
