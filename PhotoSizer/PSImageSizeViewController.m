//
//  PSImageSizeViewController.m
//  PhotoSizer
//
//  Created by Ian on 04/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSImageSizeViewController.h"
#import "PSImageSizeCell.h"
#import "PSImageViewController.h"

@interface PSImageSizeViewController ()

@end

@implementation PSImageSizeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSNumber *)getMilliseconds
{
    return [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
}

-(void) logTime:(NSString*)message
{
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString*mystamp = [NSString stringWithFormat:@"%@:%@",dateString,[self getMilliseconds]];
    
    NSLog(@"%@ %@", message,mystamp);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
        // 1
    
    [self logTime:@"Getting Asset Library"];
    
    ALAssetsLibrary *assetsLibrary = [PSImageSizeViewController defaultAssetsLibrary];
    
    
    [self logTime:@"Got Asset Library"];
    
    
        // 2
    [
        assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
        {
            [
                group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                {
                    if(result)
                    {
                    // 3
                        [tmpAssets addObject:result];
                            //NSLog(@"%@",[result valueForProperty:ALAssetPropertyAssetURL]);
                    }
                }
            ];
        
            // 4
            //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        
        
            self.assets=tmpAssets;
        
            [self logTime:@"About to sort"];
            
                //[self.tableView reloadData];
       
            /*
            self.assets =
            [
                tmpAssets sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                {
                                    
                    long long sizeA=[(ALAsset*)a defaultRepresentation].size;
                    long long sizeB=[(ALAsset*)b defaultRepresentation].size;
                    
                    return (sizeA < sizeB);
                }
            ];
             
            [self logTime:@"Sorted"];
            */
        
            //self.assets = tmpAssets;
        
            // 5
            [self.tableView reloadData];
        }
        failureBlock:^(NSError *error)
        {
            NSLog(@"Error loading images %@", error);
        }
     ];
}

-(IBAction)sort
{
        //    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        //    [self.view addSubview: activityView];
        //activityView.center = CGPointMake(240,160);
    
    [activityView startAnimating];
    
    NSArray *tmpAssets=self.assets;
    
    __block int i=0;
    
    self.assets =
    [
     tmpAssets sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
     {
         long long sizeA=[(ALAsset*)a defaultRepresentation].size;
         long long sizeB=[(ALAsset*)b defaultRepresentation].size;
         
         ++i;
         
         return (sizeA < sizeB);
     }
     ];
    
    [activityView stopAnimating];
    
    
    [self logTime:[NSString stringWithFormat:@"sorted %i",i] ];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PSImageSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
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
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ALAsset *asset = self.assets[indexPath.row];
        [[segue destinationViewController] setAsset:asset];
    }
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
