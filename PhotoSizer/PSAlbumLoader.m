    //
    //  PSAssetLoader.m
    //  PhotoSizer
    //
    //  Created by Ian on 26/02/2014.
    //  Copyright (c) 2014 Ian. All rights reserved.
    //

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSAlbumData.h"
#import "PSAlbumLoader.h"
#import "PSAssetLoader.h"

@implementation PSAlbumLoader

@synthesize assetLoaders=_assetLoaders;


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (void)main
{
    @autoreleasepool
    {
        __block NSOperationQueue* loaderQueue=[[NSOperationQueue alloc]init];
        
        ALAssetsLibrary *assetsLibrary = [PSAlbumLoader defaultAssetsLibrary];
        __block NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
        __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
        };
        
            // emumerate through our groups and only add groups that contain photos
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group)
            {
                PSAlbumData* albumData=[[PSAlbumData alloc]initWithAlbum:group];
                PSAssetLoader* assetLoader=[[PSAssetLoader alloc]initWithAlbum:albumData];
                [loaderQueue addOperation:assetLoader];
                [tmpAssets addObject:assetLoader];
            }
            else
            {
                _assetLoaders=tmpAssets;
                dispatch_semaphore_signal(sema);
            }
        };
        
        
        NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
        [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
}


@end
