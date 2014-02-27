//
//  PSImageData.h
//  PhotoSizer
//
//  Created by Ian on 12/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PSImageData : NSObject

@property ALAsset* asset;
@property long long imgSize;

@end
