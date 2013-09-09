//
//  UILabel+DigitalOcean.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/6/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "UILabel+DigitalOcean.h"

@implementation UILabel (DigitalOcean)

+ (UILabel *)do_defaultTableViewCellLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentLeft;

    return label;
}

@end
