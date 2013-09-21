//
//  AppDelegate.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "DomainsViewController.h"
#import "KeysViewController.h"
#import "ImagesViewController.h"
#import "SettingsViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:[UIColor do_blueColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor do_blueColor]];
    [[UIToolbar appearance] setTintColor:[UIColor do_blueColor]];
    [[UITabBar appearance] setTintColor:[UIColor do_blueColor]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor do_blueColor];

    self.mainController = [[MainViewController alloc] init];
    self.domainsController = [[DomainsViewController alloc] init];
    self.imagesController = [[ImagesViewController alloc] init];
    self.keysController = [[KeysViewController alloc] init];
    self.settingsController = [[SettingsViewController alloc] init];

    UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:self.mainController];
    UINavigationController *domainsNavigation = [[UINavigationController alloc] initWithRootViewController:self.domainsController];
    UINavigationController *imagesNavigation = [[UINavigationController alloc] initWithRootViewController:self.imagesController];
    UINavigationController *keysNavigation = [[UINavigationController alloc] initWithRootViewController:self.keysController];
    UINavigationController *settingsNavigation = [[UINavigationController alloc] initWithRootViewController:self.settingsController];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[ mainNavigation,
                                               imagesNavigation,
                                               keysNavigation,
                                               domainsNavigation,
                                               settingsNavigation ];
    
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    
    [self showLoginIfNecessary:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOUserDidLogoutNotification object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.authViewController) {
        id controller = self.authViewController.viewControllers[0];
        if ([controller isKindOfClass:[LoginViewController class]]) {
            NSString *clientID = [controller clientTextField].text;
            NSString *APIKey = [controller apiTextField].text;

            if (!IsEmpty(clientID)) {
                [[NSUserDefaults standardUserDefaults] setObject:clientID forKey:kUserDefaultsDraftClientIDKey];
            }

            if (!IsEmpty(APIKey)) {
                [[NSUserDefaults standardUserDefaults] setObject:APIKey forKey:kUserDefaultsDraftAPIKeyKey];
            }
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self showLoginIfNecessary:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedOut:)
                                                 name:DOUserDidLogoutNotification
                                               object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Public Methods

- (void)showLoginIfNecessary:(BOOL)animated
{
    if (self.authViewController) {
        return;
    }
    
    if (![[DigitalOceanAPIClient sharedClient] isAuthenticated]) {
        LoginViewController *loginController = [[LoginViewController alloc] init];

        self.authViewController = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        NSTimeInterval duration = animated ? 0.5 : 0.0;
        
        [UIView transitionWithView:self.window duration:duration options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^
         {
             [self.window setRootViewController:self.authViewController];
             [self.window makeKeyAndVisible];
         } completion:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userLoggedIn:)
                                                     name:DOUserDidLoginNotification
                                                   object:nil];
    } else {
        [self.mainController reloadDroplets];
    }
}

#pragma mark - Selector Methods

- (void)userLoggedIn:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOUserDidLoginNotification object:nil];
    
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^
     {
         self.tabBarController.selectedIndex = 0;

         UINavigationController *navController = (UINavigationController *)self.tabBarController.selectedViewController;
         [navController popToRootViewControllerAnimated:NO];

         [self.window setRootViewController:self.tabBarController];
         [self.window makeKeyAndVisible];
     } completion:^(BOOL finished) {
         self.authViewController = nil;
         [self.mainController reloadDroplets];
     }];
}

- (void)userLoggedOut:(NSNotification *)notification
{
    DLog(@"User LoggedOut Notification");
    
    [[DigitalOceanAPIClient sharedClient].operationQueue cancelAllOperations];
    
    [self showLoginIfNecessary:YES];
}


@end
