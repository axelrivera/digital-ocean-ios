//
//  DropletViewCell.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletViewCell.h"

@implementation DropletViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.hidden = YES;
        
        self.dropletView = [[DropletView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.dropletView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.frame.size;
    
    CGRect dropletRect = CGRectMake(10.0, 10.0, contentSize.width - 20.0, contentSize.height - 20.0);
    
    self.dropletView.frame = dropletRect;
}

@end
