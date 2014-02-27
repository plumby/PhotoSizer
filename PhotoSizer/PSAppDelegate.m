//
//  PSAppDelegate.m
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSAppDelegate.h"
#import "PSAlbumData.h"

@implementation PSAppDelegate
@synthesize albums;
@synthesize albumLoader;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadAllData];
        //[self loadAllData2];
    return YES;
}

-(void) loadAllData
{
        //sema = dispatch_semaphore_create(0);
    
    NSOperationQueue* loadQueue=[[NSOperationQueue alloc]init];
    
    NSMutableArray* ops=[[NSMutableArray alloc]init];
    
    albumLoader=[[PSAlbumLoader alloc]init];
    
    [ops addObject:albumLoader];
    
    [loadQueue addOperations:ops waitUntilFinished:TRUE];
    
    albums=albumLoader.assetLoaders;
    
     NSLog(@"Exiting loadAllData");
        //    while(!albums)
        //{
        //}
        //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}




-(void) loadAllData2
{
    sema = dispatch_semaphore_create(0);
    
    NSOperationQueue* loadQueue=[[NSOperationQueue alloc]init];
    
    NSMutableArray* ops=[[NSMutableArray alloc]init];
    
    NSInvocationOperation *loadAlbumAssetsOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                    selector:@selector(loadAssets)
                                                                                      object:nil];
    
    
    [ops addObject:loadAlbumAssetsOp];
    
    [loadQueue addOperations:ops waitUntilFinished:TRUE];
    
        //    while(!albums)
        //{
        //}
     dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
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


-(void)loadAssets
{
    ALAssetsLibrary *assetsLibrary = [PSAppDelegate defaultAssetsLibrary];
    __block NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
    };
    
        // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            PSAlbumData* albumData=[[PSAlbumData alloc]initWithAlbum:group];
                //[albumData loadAssets];
            
            [tmpAssets addObject:albumData];
        }
        else
        {
            albums=tmpAssets;
            dispatch_semaphore_signal(sema);
        }
    };
    
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}



							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
