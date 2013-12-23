//
//  PSImageSizeViewController.m
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PSImageSizeViewController.h"
#import "PSImageSizeCell.h"
#import "PSAssetViewController.h"
#import "PSImageData.h"

@interface PSImageSizeViewController ()

@end

@implementation PSImageSizeViewController

- (NSNumber *)getMilliseconds
{
    return [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
}

-(void) logTime:(NSString*)message
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString*mystamp = [NSString stringWithFormat:@"%@:%@",dateString,[self getMilliseconds]];
    
    NSLog(@"%@ %@", message,mystamp);
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}

- (void)viewDidLoad
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
    [tableView addSubview:activityIndicator];
    [activityIndicator setHidden:FALSE];
    [activityIndicator setHidesWhenStopped:FALSE];
    activityIndicator.center = tableView.center;
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [sortButton setEnabled:NO];
    
        //[NSThread detachNewThreadSelector:@selector(loadAssets) toTarget:self withObject:nil];
    [self loadAssets];
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}



-(void)loadAssets
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
        // 1
    
    ALAssetsLibrary *assetsLibrary = [PSImageSizeViewController defaultAssetsLibrary];
    [
        assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
        {
            [
                group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                {
                    if(result)
                    {
                        PSImageData* imgData=[[PSImageData alloc]init];
                        
                        imgData.assett=result;
                        imgData.imgSize=result.defaultRepresentation.size;
                        [tmpAssets addObject:imgData];
                    }
                }
            ];
        
            self.assets=tmpAssets;
            
            [self doSorting];
        }
        failureBlock:^(NSError *error)
        {
            NSLog(@"Error loading images %@", error);
        }
     ];
    
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}

-(IBAction)sort
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
    [tableView addSubview:activityIndicator];
    [activityIndicator setHidden:FALSE];
    [activityIndicator setHidesWhenStopped:FALSE];
    activityIndicator.center = tableView.center;
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [sortButton setEnabled:NO];
    
    [NSThread detachNewThreadSelector:@selector(doSorting) toTarget:self withObject:nil];
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}

-(void)doSorting
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);

    NSArray *tmpAssets=self.assets;
    
    __block int i=0;
    
    self.assets =
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
    
    [tableView reloadData];

    [sortButton setEnabled:TRUE];

    [self.view setUserInteractionEnabled:TRUE];
    [activityIndicator setHidesWhenStopped:TRUE];
    [activityIndicator stopAnimating];
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);

}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return library;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    // Return the number of sections.
    
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    // Return the number of rows in the section.
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return [self.assets count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"Cell";
    PSImageSizeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PSImageData* imgData=self.assets[indexPath.row];
    ALAsset *asset =imgData.assett;
        //UIImage *image=[UIImage imageWithCGImage:[asset thumbnail]];
        //    NSURL* s=[asset valueForProperty:ALAssetPropertyAssetURL];
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensure the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
        //NSString *formattedNumberString = [NSString stringWithFormat:@"%lli",assetRepresentation.size];
    
    NSNumber* size=[[NSNumber alloc]initWithLongLong:assetRepresentation.size/1024];
        //NSLog(@"formattedNumberString: %@", formattedNumberString);
        // Output for locale en_US: "formattedNumberString: formattedNumberString: 122,344.453"
    
    cell.sizeLabel.text=[NSString stringWithFormat:@"%@ KB",[numberFormatter stringForObjectValue:size]];

    
   
    
        //    cell.sizeLabel.text=[NSString stringWithFormat:@"%lli",assetRepresentation.size];
    cell.photoImageView.image=[UIImage imageWithCGImage:[asset thumbnail]];
    
        //[s absoluteString];
    
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return cell;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    if ([identifier isEqualToString:@"showDetail2"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSImageData* imgData=self.assets[indexPath.row];
        ALAsset *asset =imgData.assett;
       
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        
        MPMoviePlayerViewController *moviePlayerVC =[[MPMoviePlayerViewController alloc] initWithContentURL:[rep url]];
        
        /*
         [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification
         object:[moviePlayerVC moviePlayer]];
         */
        
        [moviePlayerVC.view setFrame: self.view.bounds];
        [self.view addSubview:moviePlayerVC.view];
        
        return false;
    }
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    return true;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSImageData* imgData=self.assets[indexPath.row];
        ALAsset *asset =imgData.assett;
        [[segue destinationViewController] setAsset:asset];
    }
    NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


@end
