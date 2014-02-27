//
//  PSAssetLoader.m
//  PhotoSizer
//
//  Created by Ian on 26/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSAssetLoader.h"
#import "PSImageData.h"

@implementation PSAssetLoader
@synthesize album=_album;

-(id)initWithAlbum:(PSAlbumData*)album
{
    self=[super init];
    
    if (self)
    {
        _album=album;
    }
    
    return self;
}


- (void)main
{
    @autoreleasepool
    {
        __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];

        [
         
         _album.album  enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if(result)
             {
                 PSImageData* imgData=[[PSImageData alloc]init];
                 imgData.assett=result;
                 imgData.imgSize=result.defaultRepresentation.size;
                     //imgData.imgSize=10;
                 [   tmpAssets addObject:imgData];
                  NSLog(@"Loaded album asset %@",[_album.album valueForProperty:ALAssetsGroupPropertyName]);

             }
             else
             {
                 _album.assets=[PSAlbumData doSorting:tmpAssets];
                     //                 [self populateExternalArray];
                 NSLog(@"Loaded all album assets %@",[_album.album valueForProperty:ALAssetsGroupPropertyName]);

                 dispatch_semaphore_signal(sema);
                 
             }
         }
         ];
        
         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
}






@end
