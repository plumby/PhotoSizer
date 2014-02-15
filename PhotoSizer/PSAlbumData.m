//
//  PSAlbumData.m
//  PhotoSizer
//
//  Created by Ian on 21/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSAlbumData.h"
#import "PSImageData.h"

@implementation PSAlbumData
@synthesize assets,videos,photos;
@synthesize album;
@synthesize includePhotos,includeVideo;


-(id) initWithAlbum:(ALAssetsGroup*)newAlbum
{
    self=[super init];
    
    if (self)
    {
        includePhotos=YES;
        includeVideo=YES;
        album=newAlbum;
            //[self loadAssets];
            //assets=NULL;
            //        assets=[[NSMutableArray alloc]init];
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

-(void)setIncludePhotos:(BOOL)newIncludePhotos
{
    self->includePhotos=newIncludePhotos;
    self->assets=NULL;
        //    [self populateExternalArray];
}

-(void)setIncludeVideos:(BOOL)newIncludeVideos
{
    self->includeVideo=newIncludeVideos;
        //    [self populateExternalArray];
    self->assets=NULL;
}

-(NSArray*)assets
{
    if (!self->assets)
    {
        [self populateExternalArray];
    }
    
    return self->assets;
}




-(void)loadAssets:(void(^)(void))handler
{
    _completionHandler = [handler copy];
    
    if (allAssets)
    {
        _completionHandler();
        _completionHandler=nil;
        return;
    }
    
    NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    [

        album  enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
        {
            if(result)
            {
                    PSImageData* imgData=[[PSImageData alloc]init];
                    imgData.assett=result;
                    imgData.imgSize=result.defaultRepresentation.size;
                    [tmpAssets addObject:imgData];
            }
            else
            {
                    //allAssets=tmpAssets;
                allAssets=[PSAlbumData doSorting:tmpAssets];
                    //[self doSorting];
                [self populateExternalArray];

                _completionHandler();
             
                 // Clean up.
                _completionHandler = nil;
            }
        }
     ];
}


-(void)populateExternalArray2
{
    for (PSImageData *imageData in allAssets)
    {
        ALAsset* asset=imageData.assett;
        
        if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        {
            [photos addObject:asset];
        }
        else
        {
            [videos addObject:asset];
        }
    }
}


-(void)populateExternalArray
{
    if (includeVideo && includePhotos)
    {
        self->assets=allAssets;
    }
    else
    {
        NSMutableArray *tmpAssets=[[NSMutableArray alloc]init];

        for (PSImageData *imageData in allAssets)
        {
            ALAsset* asset=imageData.assett;
            
            
            if (
                (includePhotos && [[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
                ||
                (includeVideo && [[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypeVideo"])
                )
            {
                [tmpAssets addObject:imageData];
            }
            
            if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
            {
            }
        }
        
        self->assets=tmpAssets;
    }
}


-(void)sort
{
        //[NSThread detachNewThreadSelector:@selector(doSorting) toTarget:self withObject:nil];
    //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}


+(NSArray*)doSorting:(NSArray*)unsortedArray
{
    NSArray* sortedArray;
    
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);

        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        //NSArray *tmpAssets=allAssets;
    
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
