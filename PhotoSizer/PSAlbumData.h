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
}

-(id) initWithAlbum:(ALAssetsGroup*)newAlbum;

-(void)loadAssets:(void(^)(void))handler;
-(void)doSorting;


@property (readonly) ALAssetsGroup* album;

@property (readonly) NSArray* assets;


@end
