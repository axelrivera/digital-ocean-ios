//
//  DropletViewCell.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropletViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *nameLabel;
@property (strong, nonatomic, readonly) UILabel *statusLabel;
@property (strong, nonatomic, readonly) UILabel *ipLabel;
@property (strong, nonatomic, readonly) UILabel *regionLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
