//
//  PSAppDelegate.h
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAlbumLoader.h"

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>;

@property (strong, nonatomic) UIWindow *window;
    //@property (strong) NSArray* albums;
@property (strong) PSAlbumLoader *albumLoader;

@end
