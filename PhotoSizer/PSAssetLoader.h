//
//  PSAssetLoader.h
//  PhotoSizer
//
//  Created by Ian on 26/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
#import "PSAlbumData.h"

@interface PSAssetLoader : NSOperation;

@property PSAlbumData* album;

-(id)initWithAlbum:(PSAlbumData*)album;




@end
