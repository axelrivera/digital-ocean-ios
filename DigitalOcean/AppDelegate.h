//
//  AppDelegate.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class DomainsViewController;
@class KeysViewController;
@class ImagesViewController;
@class SettingsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) DomainsViewController *domainsController;
@property (strong, nonatomic) KeysViewController *keysController;
@property (strong, nonatomic) ImagesViewController *imagesController;
@property (strong, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) UINavigationController *authViewController;

- (void)showLoginIfNecessary:(BOOL)animated;

@end
