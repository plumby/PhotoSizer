//
//  PSAlbumViewController.m
//  PhotoSizer
//
//  Created by Ian on 15/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "PSAlbumViewController.h"

@interface PSAlbumViewController ()

@end

@implementation PSAlbumViewController

NSMutableArray * assets;
NSMutableArray * albums;


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
    
    albums=[[NSMutableArray alloc]init];
    
    [self loadAssets4];
}


-(void)loadAssets
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
        // Add a task to the group
    dispatch_group_async(group, queue, ^{
        [self loadAssets3 ];
    });
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
        //    assets=tmpAssets;
    
        //[self doSorting];
    
    [tableView reloadData];
    
    
}



-(void)loadAssets3
{
    dispatch_group_t loadingGroup = dispatch_group_create();
    assets = [[NSMutableArray array] init];
    albums = [[NSMutableArray array] init];

    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if(index != NSNotFound) {
            [assets addObject:asset];
            dispatch_async(dispatch_get_main_queue(), ^{ });
        } else {
            dispatch_group_leave(loadingGroup);
        }
    };


    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [albums addObject: group];
        } else {
            NSLog(@"Found %lu albums", (unsigned long)[albums count]);
                // album loading is done
            for (ALAssetsGroup * album in albums) {
                dispatch_group_enter(loadingGroup);
                [album enumerateAssetsUsingBlock: assetEnumerator];
            }
            dispatch_group_notify(loadingGroup, dispatch_get_main_queue(), ^{
                NSLog(@"DONE: ALAsset array contains %lu elements", (unsigned long)[assets count]);
            });
        }
    };

    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];

    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum
                       usingBlock:assetGroupEnumerator
                     failureBlock: ^(NSError *error) {
                         NSLog(@"Failed.");
                     }];
    
    
}
 


-(void)loadAssets2
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        //assets = [@[] mutableCopy];
        //__block NSMutableArray *tmpAssets = [@[] mutableCopy];
        // 1
    
    ALAssetsLibrary *assetsLibrary = [PSAlbumViewController defaultAssetsLibrary];
    
    
    
    [
        assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
        {
            [albums addObject: group];
            [tableView reloadData];
             //albums
         /*
         [
          group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
          {
              if(result)
              {
                  *
                  PSImageData* imgData=[[PSImageData alloc]init];
                  
                  if (
                      (includePhotos && [[result valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
                      ||
                      (includeVideo && [[result valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypeVideo"])
                      )
                  {
                      imgData.assett=result;
                      imgData.imgSize=result.defaultRepresentation.size;
                      [tmpAssets addObject:imgData];
                  }
              }
          }
          ];
           */
         

        }
        failureBlock:^(NSError *error)
        {
            NSLog(@"Error loading images %@", error);
        }
     
     ];
    
 
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}


-(void)loadAssets4
{
    ALAssetsLibrary *assetsLibrary = [PSAlbumViewController defaultAssetsLibrary];
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
        // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
            //        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            //        [group setAssetsFilter:onlyPhotosFilter];
            //        if ([group numberOfAssets] > 0)
            //{
                //[albums addObject:<#(id)#>]
        if (group) {
            [albums addObject:group];
        }
        else
        {
            [tableView reloadData];
        }
    };
    
    
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
    
    return [albums count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"AlbumCell";
    
    
    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
        //cell.text=@"All";
    ALAssetsGroup* album=[albums objectAtIndex:indexPath.row];
    cell.textLabel.text=[album valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}


@end
