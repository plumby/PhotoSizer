//
//  PSAlbumData.h
//  PhotoSizer
//
//  Created by Ian on 21/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PSCompletionWatcher.h"


@interface PSAlbumData : NSObject
{
    NSArray* _allAssets;
}

-(id) initWithAlbum:(ALAssetsGroup*)newAlbum;

-(void)setAssets:(NSArray*)assets;

@property (readonly) ALAssetsGroup* album;
@property (readonly) NSMutableArray* videos;
@property (readonly) NSMutableArray* photos;

@property (nonatomic,readwrite) BOOL includeVideo;
@property (nonatomic,readwrite) BOOL includePhotos;


@end
