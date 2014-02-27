//
//  PSActivityPlayer.h
//  PhotoSizer
//
//  Created by Ian on 26/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSActivityPlayer : NSOperation
{
    UIActivityIndicatorView* _indicator;
}

-(id)initWithActivityIndicator:(UIActivityIndicatorView*)indicator;


@end
