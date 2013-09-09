//
//  DropletActionView.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletActionView.h"

#import "UIButton+Color.h"
#import <UIView+AutoLayout.h>

#define kDropletActionButtonHeight 44.0
#define kDropletActionViewHeight 236.0

@implementation DropletActionView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithType:DropletActionViewTypeActive frame:frame];
}

- (id)initWithType:(DropletActionViewType)viewType frame:(CGRect)frame
{
    frame.size.height = kDropletActionViewHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        _viewType = viewType;

        UIColor *buttonColor = [UIColor do_blueColor];

        _backupsActive = NO;

        UIView *topLeftView = nil;
        UIView *topRightView = nil;

        if (viewType == DropletActionViewTypeInactive) {
            _bootButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
            _bootButton.translatesAutoresizingMaskIntoConstraints = NO;
            [_bootButton setTitle:@"Boot" forState:UIControlStateNormal];
            _bootButton.tag = DODropletActionTypeBoot;

            [_bootButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:_bootButton];

            topLeftView = _bootButton;
            topRightView = _bootButton;

            // Setup AutoLayout

            [_bootButton autoSetDimension:ALDimensionHeight toSize:kDropletActionButtonHeight];
            [_bootButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0];
            [_bootButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
            [_bootButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
        } else {
            _rebootButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
            _rebootButton.translatesAutoresizingMaskIntoConstraints = NO;
            [_rebootButton setTitle:@"Reboot" forState:UIControlStateNormal];
            _rebootButton.tag = DODropletActionTypeReboot;

            [_rebootButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:_rebootButton];

            _shutdownButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
            _shutdownButton.translatesAutoresizingMaskIntoConstraints = NO;
            [_shutdownButton setTitle:@"Shut Down" forState:UIControlStateNormal];
            _shutdownButton.tag = DODropletActionTypeShutDown;

            [_shutdownButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:_shutdownButton];

            topLeftView = _rebootButton;
            topRightView = _shutdownButton;

            // Setup AutoLayout

            [_rebootButton autoSetDimension:ALDimensionHeight toSize:kDropletActionButtonHeight];
            [_rebootButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0];
            //[_rebootButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];

            [_shutdownButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_rebootButton];
            [_shutdownButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_rebootButton];
            //[_shutdownButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];

            [self autoDistributeSubviews:@[ _rebootButton, _shutdownButton ]
                               alongAxis:ALAxisHorizontal
                        withFixedSpacing:10.0
                               alignment:NSLayoutFormatAlignAllCenterY];
        }

        _passwordButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
        _passwordButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_passwordButton setTitle:@"Reset Password" forState:UIControlStateNormal];
        _passwordButton.tag = DODropletActionTypeResetPassword;

        [_passwordButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_passwordButton];

        _snapshotButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
        _snapshotButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_snapshotButton setTitle:@"Take Snapshot" forState:UIControlStateNormal];
        _snapshotButton.tag = DODropletActionTypeTakeSnapshot;

        [_snapshotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_snapshotButton];

        _backupButton = [UIButton solidButtonWithBackgroundColor:buttonColor];
        _backupButton.translatesAutoresizingMaskIntoConstraints = NO;

        [_backupButton addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_backupButton];

        // Setup AutoLayout

        [_passwordButton autoSetDimension:ALDimensionHeight toSize:kDropletActionButtonHeight];
        [_passwordButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topLeftView withOffset:10.0];
        [_passwordButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topLeftView];
        [_passwordButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topRightView];

        [_snapshotButton autoSetDimension:ALDimensionHeight toSize:kDropletActionButtonHeight];
        [_snapshotButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordButton withOffset:10.0];
        [_snapshotButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_passwordButton];
        [_snapshotButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordButton];

        [_backupButton autoSetDimension:ALDimensionHeight toSize:kDropletActionButtonHeight];
        [_backupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_snapshotButton withOffset:10.0];
        [_backupButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_snapshotButton];
        [_backupButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_snapshotButton];
    }
    return self;
}

#pragma mark - Public Methods

- (void)enableBackups
{
    [self.backupButton setTitle:@"Disable Backups" forState:UIControlStateNormal];
    self.backupsActive = YES;
}

- (void)disableBackups
{
    [self.backupButton setTitle:@"Enable Backups" forState:UIControlStateNormal];
    self.backupsActive = NO;
}

#pragma mark - Selector Methods

- (void)buttonAction:(id)sender
{
    [self.delegate actionView:self didSelectDropletAction:[sender tag]];
}

- (void)backupAction:(id)sender
{
    [self.delegate actionView:self didEnableBackups:!self.backupsActive];
}

@end
