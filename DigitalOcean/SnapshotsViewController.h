//
//  SnapshotsViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnapshotsViewController : UITableViewController

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) DODroplet *droplet;

- (id)initWithDroplet:(DODroplet *)droplet;

@end
