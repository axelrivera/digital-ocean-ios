//
//  DropletSizeViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropletSizeViewControllerDelegate;

@interface DropletSizeViewController : UITableViewController

@property (weak, nonatomic) id <DropletSizeViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) DOSize *currentSize;

- (id)initWithSizes:(NSArray *)sizes;

@end

@protocol DropletSizeViewControllerDelegate <NSObject>

- (void)dropletSizeViewControllerDidFinish:(DropletSizeViewController *)controller;

@end
