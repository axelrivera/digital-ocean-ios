//
//  ARActivityView.h
//
//  Created by Axel Rivera on 2/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARActivityView : UIView

@property (strong, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic, readonly) UILabel *textLabel;

@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic, readonly, getter = isShowing) BOOL showing;
@property (assign, nonatomic, readonly, getter = hasIndicator) BOOL indicator;

@property (assign, nonatomic) NSTimeInterval animationDuration;

- (void)setTitle:(NSString *)title indicator:(BOOL)indicator;
- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)hide;
- (void)hideAnimated:(BOOL)animated;

@end
