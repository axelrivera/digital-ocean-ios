//
//  UIButton+Color.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "UIButton+Color.h"

#import "UIImage+Tint.h"

@implementation UIButton (Color)

+ (UIButton *)solidButtonWithBackgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage backgroundTintedImageWithColor:backgroundColor]
                      forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];

    return button;
}

@end
