//
//  DropletViewCell.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletViewCell.h"

#import "UILabel+DigitalOcean.h"
#import <UIView+AutoLayout.h>

@implementation DropletViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.hidden = YES;
        
        _nameLabel = [UILabel do_defaultTableViewCellLabel];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];

        [self.contentView addSubview:_nameLabel];

        _statusLabel = [UILabel do_defaultTableViewCellLabel];
        _statusLabel.font = [UIFont systemFontOfSize:14.0];
        _statusLabel.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:_statusLabel];

        _ipLabel = [UILabel do_defaultTableViewCellLabel];
        _ipLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];

        [self.contentView addSubview:_ipLabel];

        _regionLabel = [UILabel do_defaultTableViewCellLabel];
        _regionLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _regionLabel.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:_regionLabel];

        // Setup AutoLayout

        [_nameLabel autoSetDimension:ALDimensionHeight toSize:20.0];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];

        [_statusLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_nameLabel];
        [_statusLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_nameLabel];
        [_statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
        [_statusLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeTrailing ofView:_nameLabel withOffset:1.0];

        [_ipLabel autoSetDimension:ALDimensionHeight toSize:18.0];
        [_ipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel withOffset:5.0];
        [_ipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_nameLabel];

        [_regionLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_ipLabel];
        [_regionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_ipLabel];
        [_regionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
        [_regionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeTrailing ofView:_ipLabel withOffset:1.0];
    }

    return self;
}

@end
