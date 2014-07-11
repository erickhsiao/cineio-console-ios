//
//  CineAppDelegate.h
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineSignInViewController.h"

@interface CineAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL loggedIn;
@property (weak, nonatomic) CineSignInViewController *signInViewController;

@end
