//
//  DropletImageViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropletImageViewControllerDelegate;

@interface DropletImageViewController : UITableViewController

@property (weak, nonatomic) id <DropletImageViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) DOImage *currentImage;

- (id)initWithImages:(NSArray *)images;

@end

@protocol DropletImageViewControllerDelegate <NSObject>

- (void)dropletImageViewControllerDidFinish:(DropletImageViewController *)controller;

@end
