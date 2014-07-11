//
//  CineAppDelegate.h
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineSignInViewController.h"
#import "CineUser.h"

@interface CineAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CineUser *user;
@property (weak, nonatomic) CineSignInViewController *signInViewController;

- (CineUser *)signIn:(NSDictionary *)userAttributes;
- (void)signOut;
- (BOOL)signedIn;

@end
