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
    void (^_completionHandler)(void );
    NSArray* allAssets;
    
}

-(id) initWithAlbum:(ALAssetsGroup*)newAlbum;

-(void)loadAssets:(void(^)(void))handler;
    //-(void)doSorting;
+(NSArray*)doSorting:(NSArray*)unsortedArray;


@property (readonly) ALAssetsGroup* album;
@property (readonly) NSArray* assets;
@property (readonly) NSMutableArray* videos;
@property (readonly) NSMutableArray* photos;




@property (nonatomic,readwrite) BOOL includeVideo;
@property (nonatomic,readwrite) BOOL includePhotos;


@end
