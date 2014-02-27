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
                 imgData.asset=result;
                 imgData.imgSize=result.defaultRepresentation.size;
                 [   tmpAssets addObject:imgData];
             }
             else
             {
                 _album.assets=[PSAssetLoader doSorting:tmpAssets];
                 dispatch_semaphore_signal(sema);
                 
             }
         }
         ];
        
         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
}

+(NSArray*)doSorting:(NSArray*)unsortedArray
{
    NSArray* sortedArray;
    __block int i=0;
    
    sortedArray =
    [
     unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
     {
         long long sizeA=[(PSImageData*)a imgSize];
         long long sizeB=[(PSImageData*)b imgSize];
         ++i;
         
         return (sizeA < sizeB);
     }
     ];
    return sortedArray;
}






@end
