//
//  DropletActionView.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DropletActionViewType) {
    DropletActionViewTypeActive,
    DropletActionViewTypeInactive
};

@protocol DropletActionViewDelegate;

@interface DropletActionView : UIView

@property (weak, nonatomic) id <DropletActionViewDelegate> delegate;

@property (strong, nonatomic) UIButton *bootButton;
@property (strong, nonatomic) UIButton *rebootButton;
@property (strong, nonatomic) UIButton *shutdownButton;
@property (strong, nonatomic) UIButton *passwordButton;
@property (strong, nonatomic) UIButton *snapshotButton;
@property (strong, nonatomic) UIButton *backupButton;

@property (assign, nonatomic) DropletActionViewType viewType;
@property (assign, nonatomic) BOOL backupsActive;

- (id)initWithType:(DropletActionViewType)viewType frame:(CGRect)frame;

- (void)enableBackups;
- (void)disableBackups;

@end

@protocol DropletActionViewDelegate <NSObject>

- (void)actionView:(DropletActionView *)actionView didSelectDropletAction:(DODropletActionType)dropletAction;
- (void)actionView:(DropletActionView *)actionView didEnableBackups:(BOOL)enabled;

@end
