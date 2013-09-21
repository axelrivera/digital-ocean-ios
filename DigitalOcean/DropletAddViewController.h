//
//  DropletAddViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropletAddViewControllerDelegate;

@interface DropletAddViewController : UITableViewController

@property (weak, nonatomic) id <DropletAddViewControllerDelegate> delegate;

@property (strong, nonatomic) UITextField *hostnameTextField;

@property (strong, nonatomic) NSString *currentHostname;
@property (strong, nonatomic) DOSize *currentSize;
@property (strong, nonatomic) DOSize *currentRegion;
@property (strong, nonatomic) DOImage *currentImage;

@property (strong, nonatomic) NSArray *dataSource;

@end

@protocol DropletAddViewControllerDelegate <NSObject>

- (void)dropletAddViewControllerDidFinish:(DropletAddViewController *)controller;
- (void)dropletAddViewControllerDidCancel:(DropletAddViewController *)controller;

@end