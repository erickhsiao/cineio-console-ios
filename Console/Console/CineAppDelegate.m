//
//  CineAppDelegate.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineAppDelegate.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <SSKeychain/SSKeychain.h>
#import <NSURL+ParseQuery/NSURL+QueryParser.h>
#import "CineSignInViewController.h"


@implementation CineAppDelegate

@synthesize signInViewController;
@synthesize authHandler;
@synthesize user;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    authHandler = [[CineAuthHandler alloc] init];

    [self setUpAuthObservers];

    if (![self signedIn]) {
        [self tryAutoSignInOrShowSignInScreen];
    }
    
    return YES;
}

- (void)setUpAuthObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateUser:)
                                                 name:@"SignInSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateUser:)
                                                 name:@"UpdateUserNameSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignOut)
                                                 name:@"SignOutSuccess"
                                               object:nil];
}

- (void)didUpdateUser:(NSNotification *)notification
{
    NSLog(@"appDelegate didUpdateUser");
    user = [notification userInfo][@"user"];
    [SSKeychain setPassword:user.masterKey forService:@"cine.io" account:user.email];
}

- (void)didSignOut
{
    NSLog(@"appDelegate didSignOut");
    [SSKeychain deletePasswordForService:@"cine.io" account:user.email];
    user = nil;
    [self showSignInScreen:NO];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"appDelegate handleOpenURL: %@", url);
    if ([url.host isEqualToString:@"login"]) {
        NSString *masterKey = [url parseQuery][@"masterKey"];
        [authHandler signInWithMasterKey:masterKey];        
    }
    
    return YES;
}

- (BOOL)signedIn
{
    return !!user;
}

- (void)tryAutoSignInOrShowSignInScreen
{
    NSArray *accounts = [SSKeychain accountsForService:@"cine.io"];
    if ([accounts count]) {
        // try to sign-in
        NSString *email = accounts[0][@"acct"];
        NSString *masterKey = [SSKeychain passwordForService:@"cine.io" account:email];
        [authHandler signInWithMasterKey:masterKey];
    } else {
        [self showSignInScreen:NO];
    }
}

- (void)showSignInScreen:(BOOL)animated
{
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    signInViewController = (CineSignInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"signInScreen"];
    
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:signInViewController animated:animated completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
