//
//  AppDelegate.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:[UIColor do_blueColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor do_blueColor]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor do_blueColor];

    self.mainViewController = [[MainViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    [self.window setRootViewController:self.navigationController];
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
    if (![[MaritimoAPIClient sharedClient] isAuthenticated]) {
        LoginViewController *loginController = [[LoginViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        
        [UIView transitionWithView:self.window duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^
         {
             [self.window setRootViewController:navController];
             [self.window makeKeyAndVisible];
         } completion:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userLoggedIn:)
                                                     name:DOUserDidLoginNotification
                                                   object:nil];
    } else {
        [self.mainViewController reloadDroplets];
    }
}

#pragma mark - Selector Methods

- (void)userLoggedIn:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOUserDidLoginNotification object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^
     {
         [self.window setRootViewController:self.navigationController];
         [self.window makeKeyAndVisible];
     } completion:^(BOOL finished) {
         [self.mainViewController reloadDroplets];
     }];
}

- (void)userLoggedOut:(NSNotification *)notification
{
    DLog(@"User LoggedOut Notification");
    
    [[DigitalOceanAPIClient sharedClient].operationQueue cancelAllOperations];
    
    [self showLoginIfNecessary:YES];
}


@end
