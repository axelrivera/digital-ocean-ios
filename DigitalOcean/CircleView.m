//
//  CircleView.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/15/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "CircleView.h"

#import <QuartzCore/QuartzCore.h>

@interface CircleView ()

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _contentColor = [UIColor blackColor];
    }
    return self;
}

- (void)setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);
    CGContextFillPath(context);
}

@end
