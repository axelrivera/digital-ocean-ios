//
//  DropletRegionViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropletRegionViewControllerDelegate;

@interface DropletRegionViewController : UITableViewController

@property (weak, nonatomic) id <DropletRegionViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) DORegion *currentRegion;

- (id)initWithRegions:(NSArray *)regions;

@end

@protocol DropletRegionViewControllerDelegate <NSObject>

- (void)dropletRegionViewControllerDidFinish:(DropletRegionViewController *)controller;

@end
