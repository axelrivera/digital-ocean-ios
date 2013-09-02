//
//  DropletView.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/14/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleView.h"

@interface DropletView : UIView

@property (strong, nonatomic, readonly) CircleView *statusView;

@property (strong, nonatomic, readonly) UILabel *nameLabel;
@property (strong, nonatomic, readonly) UILabel *ipLabel;
@property (strong, nonatomic, readonly) UILabel *regionLabel;
@property (strong, nonatomic, readonly) UILabel *distroLabel;
@property (strong, nonatomic, readonly) UILabel *memoryLabel;

+ (CGFloat)dropletViewHeight;

@end
