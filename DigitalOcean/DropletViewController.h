//
//  DropletViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropletViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DODroplet *droplet;
@property (strong, nonatomic) NSArray *dataSource;

- (id)initWithDroplet:(DODroplet *)droplet;

@end
