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
@synthesize assets;
    //NSMutableArray* assets;
@synthesize album;

-(id) initWithAlbum:(ALAssetsGroup*)newAlbum
{
    self=[super init];
    
    if (self)
    {
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



-(void)loadAssets:(void(^)(void))handler
{
        //ALAssetsLibrary *assetsLibrary = [PSAlbumData defaultAssetsLibrary];
    
        //ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        //{
        //};
    
    _completionHandler = [handler copy];
    
    if (assets) {
        _completionHandler();
        _completionHandler=nil;
        return;
    }
    
    NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
    
    [album  enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result)
         {
             PSImageData* imgData=[[PSImageData alloc]init];
             
                 //if (
                 //                     (includePhotos && [[result valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
                 //||
                 //(includeVideo && [[result valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypeVideo"])
                 //)
                 //{
             imgData.assett=result;
             imgData.imgSize=result.defaultRepresentation.size;
             [tmpAssets addObject:imgData];
                 //}
         }
         else
         {
             assets=tmpAssets;
             [self doSorting];
             _completionHandler();
             
                 // Clean up.
             _completionHandler = nil;
         }
     }
     ];
    
    
     //NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
     //[assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}


-(void)sort
{
    [NSThread detachNewThreadSelector:@selector(doSorting) toTarget:self withObject:nil];
    //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}


-(void)doSorting
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    NSArray *tmpAssets=self.assets;
    
    __block int i=0;
    
    self->assets =
    [
     tmpAssets sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
     {
         long long sizeA=[(PSImageData*)a imgSize];
         long long sizeB=[(PSImageData*)b imgSize];
         
             //long long sizeA=[(ALAsset*)a defaultRepresentation].size;
             //long long sizeB=[(ALAsset*)b defaultRepresentation].size;
         
         ++i;
         
         return (sizeA < sizeB);
     }
     ];
    
        //[tableView reloadData];
    
        //[sortButton setEnabled:TRUE];
    
        //[self.view setUserInteractionEnabled:TRUE];
        //[activityIndicator setHidesWhenStopped:TRUE];
        //[activityIndicator stopAnimating];
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}








@end
