//
//  PSAssetDetailViewController.m
//  PhotoSizer
//
//  Created by Ian on 18/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "PSAssetDetailViewController.h"

@interface PSAssetDetailViewController ()

@end

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
    
    NSDate *date=[_asset valueForProperty:ALAssetPropertyDate];
    dateLabel.text=[NSDateFormatter localizedStringFromDate:date
                                                  dateStyle:NSDateFormatterShortStyle
                                                  timeStyle:NSDateFormatterShortStyle];
    
    
    NSDictionary *dict=[_asset.defaultRepresentation metadata];
    
    [generalTextField setText:[NSString stringWithFormat:@"my dictionary is %@", dict]];
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
