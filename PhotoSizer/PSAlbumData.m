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
@synthesize videos,photos;
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
    }
    
    return self;
}

-(void)setAssets:(NSArray *)newAssets
{
    self->_allAssets=newAssets;
    [self populateExternalArray];
}



-(void)populateExternalArray
{
    photos=[[NSMutableArray alloc]init];
    videos=[[NSMutableArray alloc]init];
    
    for (PSImageData *imageData in _allAssets)
    {
        ALAsset* asset=imageData.asset;
        
        if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        {
            [photos addObject:imageData];
        }
        else if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypeVideo"])
        {
            [videos addObject:imageData];
        }
    }
}










@end
