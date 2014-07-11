//
//  CineSignInViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXOAuth2.h"

@interface CineSignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *signInGithubButton;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceButton;

- (IBAction)signIn:(id)sender;
- (IBAction)signInGithub:(id)sender;
- (IBAction)toggleForm:(id)sender;
- (IBAction)showTermsOfService:(id)sender;

- (void)initGithubOAuth;
- (void)handleGithubCallback:(NSURL *)url;
- (void)handleGithubSignInSuccess:(NXOAuth2Account *)account;


@end
