//
//  DropletViewCell.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DropletView.h"

@interface DropletViewCell : UITableViewCell

@property (strong, nonatomic) DropletView *dropletView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
