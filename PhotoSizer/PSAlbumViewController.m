    //
    //  PSAlbumViewController.m
    //  PhotoSizer
    //
    //  Created by Ian on 15/01/2014.
    //  Copyright (c) 2014 Ian. All rights reserved.
    //

#import <AssetsLibrary/AssetsLibrary.h>

#import "PSAlbumViewController.h"
#import "PSImageData.h"
#import "PSImageSizeViewControllerV2.h"
#import "PSAlbumData.h"
#import "PSAppDelegate.h"
#import "PSAssetLoader.h"

@interface PSAlbumViewController ()

@end

@implementation PSAlbumViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
            // Custom initialization
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


- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    PSAppDelegate* app=[[UIApplication sharedApplication] delegate];
    
    assets=[app albums];
        //assets=[[NSMutableArray alloc]init];
    
        //[self loadAssets];
}




-(void)loadAssets
{
    ALAssetsLibrary *assetsLibrary = [PSAlbumViewController defaultAssetsLibrary];
    NSMutableArray* tmpAssets=[[NSMutableArray alloc]init];
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
    };
    
        // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            PSAlbumData* albumData=[[PSAlbumData alloc]initWithAlbum:group];
            
            [tmpAssets addObject:albumData];
        }
        else
        {
            assets=tmpAssets;
                //[self sort];
            [tableView reloadData];
        }
    };
    
        //
    
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of sections.
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        // Return the number of rows in the section.
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return [assets count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"AlbumCell";
    
    
    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
        //cell.text=@"All";
    
    PSAssetLoader *loader=[assets objectAtIndex:indexPath.row];
    PSAlbumData* albumData=loader.album;
    
    ALAssetsGroup* album=albumData.album ;
    cell.textLabel.text=[album valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}


- (void) threadStartAnimating:(id)data {
    PSAlbumData *albumData=data;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    activityIndicator.center = tableView.center;
    
    [tableView addSubview:activityIndicator];
    [activityIndicator setHidden:FALSE];
    [activityIndicator setHidesWhenStopped:FALSE];
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    
    [activityIndicator startAnimating];
    
    if ([albumData isLoaded])
    {
        [self.view setUserInteractionEnabled:TRUE];
        [activityIndicator setHidesWhenStopped:TRUE];
        [activityIndicator stopAnimating];
    }
}

-(void)threadStopAnimating
{
    [self.view setUserInteractionEnabled:TRUE];
    [activityIndicator setHidesWhenStopped:TRUE];
    [activityIndicator stopAnimating];
}



- (void) animateActivity {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
    [tableView addSubview:activityIndicator];
    [activityIndicator setHidden:FALSE];
    [activityIndicator setHidesWhenStopped:FALSE];
    activityIndicator.center = tableView.center;
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    
    [activityIndicator startAnimating];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
   
    
    [self.view setUserInteractionEnabled:TRUE];
    [activityIndicator setHidesWhenStopped:TRUE];
    [activityIndicator stopAnimating];
}



- (void)prepareForSegue3:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotos"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];
        
        if ([albumData isLoaded])
        {
            [[segue destinationViewController] setAlbum:albumData];
        }
        
        NSOperationQueue* loadQueue1=[[NSOperationQueue alloc]init];
        NSOperationQueue* loadQueue2=[[NSOperationQueue alloc]init];
        
        NSMutableArray* ops1=[[NSMutableArray alloc]init];
        NSMutableArray* ops2=[[NSMutableArray alloc]init];
        
        NSInvocationOperation *startActivityOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(threadStartAnimating:)
                                                                                  object:albumData];
        
        NSInvocationOperation *loadAlbumAssetsOp = [[NSInvocationOperation alloc] initWithTarget:albumData
                                                                                      selector:@selector(loadAssets)
                                                                                        object:nil];
        
        
        NSInvocationOperation *stopActivityOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                      selector:@selector(threadStopAnimating)
                                                                                        object:nil];
        

        [ops1 addObject:startActivityOp];
        
        [loadQueue1 addOperations:ops1 waitUntilFinished:TRUE];
        
        [ops2 addObject:loadAlbumAssetsOp];
        [ops2 addObject:stopActivityOp];
        
        
        [loadQueue2 addOperations:ops2 waitUntilFinished:TRUE];
        
        [[segue destinationViewController] setAlbum:albumData];
    }
}


- (void)prepareForSegue2:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotos"])
    {
        NSOperationQueue* loadQueue=[[NSOperationQueue alloc]init];
        
        [loadQueue addOperationWithBlock:^{
             activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
             
             [tableView addSubview:activityIndicator];
             [activityIndicator setHidden:FALSE];
             [activityIndicator setHidesWhenStopped:FALSE];
             activityIndicator.center = tableView.center;
             
             [activityIndicator startAnimating];
             [self.view setUserInteractionEnabled:NO];
             
             
             [activityIndicator startAnimating];
         }];
        
        [loadQueue addOperationWithBlock:^{
            NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
            PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];
            
            if ([albumData isLoaded])
            {
                [[segue destinationViewController] setAlbum:albumData];
            }
            else
            {
                
                [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:albumData];
                
                
                [
                 albumData loadAssets:^(void)
                 {
                     [self.view setUserInteractionEnabled:TRUE];
                     [activityIndicator setHidesWhenStopped:TRUE];
                     [activityIndicator stopAnimating];
                     
                     [[segue destinationViewController] setAlbum:albumData];
                 }
                 ];
            }
        }];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    
    PSAssetLoader *loader=[assets objectAtIndex:indexPath.row];
    
    
    if(!loader.isFinished)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        
        [tableView addSubview:activityIndicator];
        [activityIndicator setHidden:FALSE];
        [activityIndicator setHidesWhenStopped:FALSE];
        activityIndicator.center = tableView.center;
        
        [activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
        
        
        [activityIndicator startAnimating];

        __block PSAlbumViewController* tempSelf=self;
    
        [loader setCompletionBlock:^(void)
         {
             [tempSelf performSelectorOnMainThread:@selector(albumLoaded) withObject:nil waitUntilDone:YES];
         }];
    }
    
    
    return loader.isFinished;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        //[NSThread detachNewThreadSelector:@selector(animateActivity) toTarget:self withObject:nil];
    
    sema = dispatch_semaphore_create(0);
    
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    
    PSAssetLoader *loader=[assets objectAtIndex:indexPath.row];
    
        //[loader waitUntilFinished];
    
        //PSAlbumData* albumData=loader.album;
    
    [self.view setUserInteractionEnabled:TRUE];
    [activityIndicator setHidesWhenStopped:TRUE];
    [activityIndicator stopAnimating];
    
    
    [[segue destinationViewController] setLoader:loader];
}

-(void)albumLoaded
{
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
}





- (void)prepareForSegueX:(UIStoryboardSegue *)segue sender:(id)sender
{
    sema = dispatch_semaphore_create(0);

    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];
    
    if ([albumData isLoaded])
    {
        [[segue destinationViewController] setAlbum:albumData];
    }
    else
    {
        
        [NSThread detachNewThreadSelector:@selector(animateActivity) toTarget:self withObject:nil];
        
        
        [
         albumData loadAssets:^(void)
         {
             dispatch_semaphore_signal(sema);
             
             [[segue destinationViewController] setAlbum:albumData];
         }
         ];
    }
}


/*
-(void) loadAlbum
{
 
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSAlbumData* albumData=[assets objectAtIndex:indexPath.row];
        
        if ([albumData isLoaded])
        {
            [[segue destinationViewController] setAlbum:albumData];
        }
        else
        {
        
            [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:albumData];
            
            
            [
             albumData loadAssets:^(void)
             {
                 [self.view setUserInteractionEnabled:TRUE];
                 [activityIndicator setHidesWhenStopped:TRUE];
                 [activityIndicator stopAnimating];
                 
                 [[segue destinationViewController] setAlbum:albumData];
             }
             ];
        }
        
        
            //        ALAssetsGroup* album=albumData.album ;
        
            //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    }
}*/


@end
