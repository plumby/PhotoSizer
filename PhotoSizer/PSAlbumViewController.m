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
#import "PSImageSizeViewControllerV2.h"
#import "PSAlbumData.h"

@interface PSAlbumViewController ()

@end

@implementation PSAlbumViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return library;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    assets=[[NSMutableArray alloc]init];
    
    [self loadAssets];
}




-(void)loadAssets
{
    ALAssetsLibrary *assetsLibrary = [PSAlbumViewController defaultAssetsLibrary];
    NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
    };
    
        // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        
            //        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            //        [group setAssetsFilter:onlyPhotosFilter];
            //        if ([group numberOfAssets] > 0)
            //{
            //[albums addObject:<#(id)#>]
        if (group)
        {
            PSAlbumData* albumData=[[PSAlbumData alloc]initWithAlbum:group];
            
            [tmpAssets addObject:albumData];
        }
        else
        {
            assets=tmpAssets;
                //[self sort];
            [tableView reloadData];
        }
    };
    
        //
    
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of sections.
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of rows in the section.
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return [assets count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"AlbumCell";
    
    
    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
        //cell.text=@"All";
    PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];

    ALAssetsGroup* album=albumData.album ;
    cell.textLabel.text=[album valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showPhotos"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        
        PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];
        
            //        ALAssetsGroup* album=albumData.album ;
        [[segue destinationViewController] setAlbum:albumData];
    }
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}


@end
