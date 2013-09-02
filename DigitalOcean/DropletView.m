//
//  DropletView.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletView.h"

#define kDropletViewStatusHeight 12.0
#define kDropletViewNameHeight 20.0
#define kDropletViewIPHeight 18.0
#define kDropletViewRegionHeight kDropletViewIPHeight
#define kDropletViewDistroHeight kDropletViewIPHeight
#define kDropletViewMemoryHeight kDropletViewIPHeight
#define kDropletViewVerticalPadding 3.0

@interface DropletView ()

@property (strong, nonatomic, readwrite) CircleView *statusView;

@property (strong, nonatomic, readwrite) UILabel *nameLabel;
@property (strong, nonatomic, readwrite) UILabel *ipLabel;
@property (strong, nonatomic, readwrite) UILabel *regionLabel;
@property (strong, nonatomic, readwrite) UILabel *distroLabel;
@property (strong, nonatomic, readwrite) UILabel *memoryLabel;

@end

@implementation DropletView

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = [DropletView dropletViewHeight];
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _statusView = [[CircleView alloc] initWithFrame:CGRectZero];
        [self addSubview:_statusView];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.highlightedTextColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];

        _ipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ipLabel.backgroundColor = [UIColor clearColor];
        _ipLabel.textColor = [UIColor blackColor];
        _ipLabel.highlightedTextColor = [UIColor whiteColor];
        _ipLabel.font = [UIFont systemFontOfSize:14.0];
        _ipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_ipLabel];

        _regionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _regionLabel.backgroundColor = [UIColor clearColor];
        _regionLabel.textColor = [UIColor blackColor];
        _regionLabel.highlightedTextColor = [UIColor whiteColor];
        _regionLabel.font = [UIFont systemFontOfSize:14.0];
        _regionLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_regionLabel];
        
        _distroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distroLabel.backgroundColor = [UIColor clearColor];
        _distroLabel.textColor = [UIColor blackColor];
        _distroLabel.highlightedTextColor = [UIColor whiteColor];
        _distroLabel.font = [UIFont systemFontOfSize:14.0];
        _distroLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_distroLabel];
        
        _memoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _memoryLabel.backgroundColor = [UIColor clearColor];
        _memoryLabel.textColor = [UIColor blackColor];
        _memoryLabel.highlightedTextColor = [UIColor whiteColor];
        _memoryLabel.font = [UIFont systemFontOfSize:14.0];
        _memoryLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_memoryLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = [DropletView dropletViewHeight];
    [super setFrame:frame];
}

- (void)layoutSubviews
{    
    CGSize contentSize = self.frame.size;

    CGRect statusRect = CGRectMake(0.0,
                                   (contentSize.height / 2.0) - (kDropletViewStatusHeight / 2.0),
                                   kDropletViewStatusHeight,
                                   kDropletViewStatusHeight);

    CGFloat contentX = statusRect.origin.x + statusRect.size.width + 10.0;
    CGFloat contentWidth = contentSize.width - contentX;

    CGFloat startY = 0.0;

    CGRect nameRect = CGRectMake(contentX, startY, contentWidth, kDropletViewNameHeight);

    startY += nameRect.size.height + kDropletViewVerticalPadding;

    CGRect ipRect = CGRectMake(contentX, startY, contentWidth / 2.0, kDropletViewIPHeight);

    CGRect regionRect = CGRectMake(ipRect.origin.x + ipRect.size.width,
                                   startY,
                                   contentWidth / 2.0,
                                   kDropletViewRegionHeight);

    startY += ipRect.size.height + kDropletViewVerticalPadding;
    
    CGFloat distroRate = 0.8;
    
    CGRect distroRect = CGRectMake(contentX, startY, contentWidth * distroRate, kDropletViewDistroHeight);
    
    CGRect memoryRect = CGRectMake(distroRect.origin.x + distroRect.size.width,
                                   startY,
                                   contentWidth * (1.0 - distroRate),
                                   kDropletViewMemoryHeight);

    self.statusView.frame = statusRect;
    self.nameLabel.frame = nameRect;
    self.ipLabel.frame = ipRect;
    self.regionLabel.frame = regionRect;
    self.distroLabel.frame = distroRect;
    self.memoryLabel.frame = memoryRect;
}

+ (CGFloat)dropletViewHeight
{
    return kDropletViewNameHeight + kDropletViewVerticalPadding + kDropletViewIPHeight + kDropletViewVerticalPadding + kDropletViewDistroHeight;
}

@end
