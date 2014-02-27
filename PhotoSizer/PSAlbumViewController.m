    //
    //  PSAlbumViewController.m
    //  PhotoSizer
    //
    //  Created by Ian on 15/01/2014.
    //  Copyright (c) 2014 Ian. All rights reserved.
    //

#import <AssetsLibrary/AssetsLibrary.h>

#import "PSAlbumViewController.h"
#import "PSImageData.h"
#import "PSImageSizeViewController.h"
#import "PSAlbumData.h"
#import "PSAppDelegate.h"
#import "PSAssetLoader.h"

@interface PSAlbumViewController ()

@end

@implementation PSAlbumViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
            // Custom initialization
    }
    return self;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    PSAppDelegate* app=[[UIApplication sharedApplication] delegate];
    
    _albums=[app albums];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_albums count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumCell";
    
    
    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PSAssetLoader *loader=[_albums objectAtIndex:indexPath.row];
    PSAlbumData* albumData=loader.album;
    
    ALAssetsGroup* album=albumData.album ;
    cell.textLabel.text=[album valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    
    PSAssetLoader *loader=[_albums objectAtIndex:indexPath.row];
    
    
    if(!loader.isFinished)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        
        [_tableView addSubview:_activityIndicator];
        [_activityIndicator setHidden:FALSE];
        [_activityIndicator setHidesWhenStopped:FALSE];
        _activityIndicator.center = _tableView.center;
        
        [_activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
        
        
        [_activityIndicator startAnimating];

        __block PSAlbumViewController* tempSelf=self;
    
        [loader setCompletionBlock:^(void)
         {
             [tempSelf performSelectorOnMainThread:@selector(albumLoaded) withObject:nil waitUntilDone:YES];
         }];
    }
    
    
    return loader.isFinished;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    
    PSAssetLoader *loader=[_albums objectAtIndex:indexPath.row];
    
    [self.view setUserInteractionEnabled:TRUE];
    [_activityIndicator setHidesWhenStopped:TRUE];
    [_activityIndicator stopAnimating];
    
    
    [[segue destinationViewController] setLoader:loader];
}

-(void)albumLoaded
{
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
}





@end
