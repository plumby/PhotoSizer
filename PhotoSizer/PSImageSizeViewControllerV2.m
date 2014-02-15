//
//  PSImageSizeViewControllerV2.m
//  PhotoSizer
//
//  Created by Ian on 19/01/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSImageSizeViewControllerV2.h"
#import "PSImageSizeCell.h"
#import "PSImageData.h"
#import "PSAssetViewController.h"

@interface PSImageSizeViewControllerV2 ()

@end

@implementation PSImageSizeViewControllerV2



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        //assets=[[NSMutableArray alloc]init];
        //[self loadAssets];
    
    /*
    
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
        [tableView addSubview:activityIndicator];
        [activityIndicator setHidden:FALSE];
        [activityIndicator setHidesWhenStopped:FALSE];
        activityIndicator.center = tableView.center;
    
        [activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
    
    
    
    [
        album loadAssets:^(void)
        {
            [self.view setUserInteractionEnabled:TRUE];
            [activityIndicator setHidesWhenStopped:TRUE];
            [activityIndicator stopAnimating];
            
            [tableView reloadData];
        }
     ];
     */
    
    [tableView reloadData];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAlbum:(PSAlbumData*) newAlbum
{
    album=newAlbum;
}



/*
-(void)loadAssets
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        //   _assets = [@[] mutableCopy];
        __block NSMutableArray *tmpAssets = [@[] mutableCopy];
        // 1
    
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
              }
          }
     ];
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}



-(IBAction)sort
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
        //    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
        //    [tableView addSubview:activityIndicator];
        //[activityIndicator setHidden:FALSE];
        //[activityIndicator setHidesWhenStopped:FALSE];
        //activityIndicator.center = tableView.center;
    
        //[activityIndicator startAnimating];
        //[self.view setUserInteractionEnabled:NO];
        //[sortButton setEnabled:NO];
    
    [NSThread detachNewThreadSelector:@selector(doSorting) toTarget:self withObject:nil];
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}


-(void)doSorting
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    NSArray *tmpAssets=self->assets;
    
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
    
    [tableView reloadData];
    
        //[sortButton setEnabled:TRUE];
    
    [self.view setUserInteractionEnabled:TRUE];
        //[activityIndicator setHidesWhenStopped:TRUE];
        //[activityIndicator stopAnimating];
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}
 */



#pragma mark - Table view data source

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
    
        //return [assets count];
        //    return [self.album.assets count]
    
    return [album.assets count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"Cell";
    PSImageSizeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PSImageData* imgData=album.assets[indexPath.row];
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
    
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
    return cell;
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        album.includePhotos=YES;
        album.includeVideo=NO;
    }
    else if (selectedSegment == 1)
    {
        album.includePhotos=NO;
        album.includeVideo=YES;
    }
    else
    {
        album.includePhotos=YES;
        album.includeVideo=YES;
    }
    [tableView reloadData];
        //[self loadAssets];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //NSLog(@"Entering %s",__PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        PSImageData* imgData=album.assets[indexPath.row];
        ALAsset *asset =imgData.assett;
        [[segue destinationViewController] setAsset:asset];
    }
        //NSLog(@"Leaving %s",__PRETTY_FUNCTION__);
    
}



@end
