//
//  CineSignInViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CineSignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *signInView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *signInGithubButton;

@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceButton;

- (IBAction)signInOrSignUp:(id)sender;
- (IBAction)signInGithub:(id)sender;
- (IBAction)toggleSignInOrPasswordRecoveryForm:(id)sender;
- (IBAction)showTermsOfService:(id)sender;
- (IBAction)join:(id)sender;

- (void)handleSignInRedirect:(NSURL *)url;


@end
