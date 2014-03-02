//
//  PSAssetDetailViewController.m
//  PhotoSizer
//
//  Created by Ian on 18/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSAssetDetailViewController.h"
#import "MyLocation.h"

@interface PSAssetDetailViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation PSAssetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGSize imageSize=_asset.defaultRepresentation.dimensions;
    
    NSString* dimensionText=[NSString stringWithFormat:@"%4.0fx%4.0f",imageSize.width,imageSize.height];
    
    NSDate *date=[_asset valueForProperty:ALAssetPropertyDate];
        //NSString*
    NSString* dateText=[NSDateFormatter localizedStringFromDate:date
                                                      dateStyle:NSDateFormatterShortStyle
                                                      timeStyle:NSDateFormatterShortStyle];
    dateLabel.text=dateText;
    
    
    
    NSDictionary *dict=[_asset.defaultRepresentation metadata];
    
    [generalTextField setText:[NSString stringWithFormat:@"my dictionary is %@", dict]];
    
    CLLocation* location=[_asset valueForProperty:ALAssetPropertyLocation];
    
    
    CLLocationCoordinate2D zoomLocation;
    
    zoomLocation.latitude=location.coordinate.latitude;
    zoomLocation.longitude=location.coordinate.longitude;
    
    
        //.latitude = 39.281516;
        //zoomLocation.longitude= -76.580806;
    
        // 2
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
        // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    [self reverseGeocode:location withLabel:dimensionText];
}


- (void)reverseGeocode:(CLLocation *)location withLabel:(NSString*)labelText{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLLocationCoordinate2D zoomLocation;
            
            zoomLocation.latitude=location.coordinate.latitude;
            zoomLocation.longitude=location.coordinate.longitude;
            
            CLPlacemark *placemark = [placemarks lastObject];
                //            self.myAddress.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
            
            MyLocation *annotation = [[MyLocation alloc] initWithName:placemark.locality address:labelText coordinate:zoomLocation] ;
            [_mapView addAnnotation:annotation];
            
            
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAsset:(ALAsset*)newDetailItem
{
    if (_asset != newDetailItem) {
        _asset = newDetailItem;
        
            // Update the view.
            //[self configureView];
    }
}


@end
