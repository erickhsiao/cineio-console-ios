//
//  CineSignInViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineSignInViewController.h"
#import "CineWebViewController.h"
#import "CineAppDelegate.h"
#import "AFNetworking.h"


@interface CineSignInViewController () <UITextFieldDelegate>
{
    CineWebViewController *_webViewController;
}

@end

@implementation CineSignInViewController

@synthesize signInView;
@synthesize activityIndicatorView;
@synthesize statusLabel;

@synthesize orLabel;
@synthesize emailField;
@synthesize passwordField;
@synthesize signInButton;
@synthesize forgotPasswordButton;

@synthesize welcomeLabel;
@synthesize nameField;
@synthesize joinButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    UIStoryboard *storyboard = window.rootViewController.storyboard;
    _webViewController = (CineWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"webScreen"];

    [self setUpAuthObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissWebView:)
                                                 name:@"WebViewDismissed"
                                               object:nil];
    
    [self showSignInForm];
    statusLabel.text = nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)setUpAuthObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignIn:)
                                                 name:@"SignInSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailToSignIn:)
                                                 name:@"SignInFailure"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateUserName:)
                                                 name:@"UpdateUserNameSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailToUpdateUserName:)
                                                 name:@"UpdateUserNameFailure"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didInitiatePasswordRecovery:)
                                                 name:@"InitiatePasswordRecoverySuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailToInitiatePasswordRecovery:)
                                                 name:@"InitiatePasswordRecoveryFailure"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignOut:)
                                                 name:@"SignOutSuccess"
                                               object:nil];
}

#pragma mark - Notifications

- (void)didSignIn:(NSNotification *)notification
{
    CineUser *user = [notification userInfo][@"user"];
    NSLog(@"signed in user name: %@", user.name);
    if (![user.name length]) {
        // if the user signed-in using GitHub, the webViewController will be open,
        // so we need to close it first
        if (_webViewController.isViewLoaded && _webViewController.view.window) {
            [_webViewController dismissViewControllerAnimated:YES completion:^{
                [self showJoinForm];
            }];
        } else {
            [self showJoinForm];
        }
    } else {
        NSLog(@"%@ <%@> signed in", user.name, user.email);
        // if the user signed-in using GitHub, the webViewController will be open,
        // so we need to close it first
        if (_webViewController.isViewLoaded && _webViewController.view.window) {
            [_webViewController dismissViewControllerAnimated:YES completion:^{
                [self setBusy:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [self setBusy:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didFailToSignIn:(NSNotification *)notification
{
    NSError *error = [notification userInfo][@"error"];
    statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
    [self setBusy:NO];
}

- (void)didUpdateUserName:(NSNotification *)notification
{
    [self setBusy:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFailToUpdateUserName:(NSNotification *)notification
{
    NSError *error = [notification userInfo][@"error"];
    statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
    [self setBusy:NO];
}

- (void)didInitiatePasswordRecovery:(NSNotification *)notification
{
    [self setBusy:NO];
}

- (void)didFailToInitiatePasswordRecovery:(NSNotification *)notification
{
    NSError *error = [notification userInfo][@"error"];
    statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
    [self setBusy:NO];
}

- (void)didSignOut:(NSNotification *)notification
{
}

- (void)didDismissWebView:(NSNotification *)notification
{
    NSLog(@"signInViewController didDismissWebView");
    [self setBusy:NO];
}

#pragma mark UI state changes

- (void)showSignInForm
{
    [self setBusy:NO];
    orLabel.hidden = NO;
    emailField.hidden = NO;
    passwordField.hidden = NO;
    signInButton.hidden = NO;
    forgotPasswordButton.hidden = NO;
    
    welcomeLabel.hidden = YES;
    nameField.hidden = YES;
    joinButton.hidden = YES;
}

- (void)showJoinForm
{
    [self setBusy:NO];
    welcomeLabel.hidden = NO;
    nameField.hidden = NO;
    joinButton.hidden = NO;

    orLabel.hidden = YES;
    emailField.hidden = YES;
    passwordField.hidden = YES;
    signInButton.hidden = YES;
    forgotPasswordButton.hidden = YES;

    [nameField becomeFirstResponder];
}

- (void)setBusy:(BOOL)busy
{
    if (busy) {
        statusLabel.text = nil;
        [signInView setUserInteractionEnabled:NO];
        [signInView setHidden:YES];
        [activityIndicatorView startAnimating];
    } else {
        [activityIndicatorView stopAnimating];
        [signInView setHidden:NO];
        [signInView setUserInteractionEnabled:YES];
    }
}

- (IBAction)signInWithGithub:(id)sender {
    [self setBusy:YES];
    
    // modally show the web view controller
    [self presentViewController:_webViewController animated:YES completion:nil];
    _webViewController.viewType = kViewTypeCancel;
    
    // request the Github authentication URL
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:@"https://www.cine.io/auth/github?client=iOS&plan=free"]];
    [_webViewController.webView loadRequest:requestUrl];
}

- (IBAction)signInOrSignUpOrRecoverPassword:(id)sender {
    [self setBusy:YES];
    if (passwordField.isEnabled) {
        [self signIn];
    } else {
        [self recoverPassword];
    }
}

- (void)signIn
{
    NSLog(@"signInViewController signIn");
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.authHandler signInWithEmail:emailField.text andPassword:passwordField.text];
}

- (void)recoverPassword
{
    NSLog(@"signInViewController recoverPassword");
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.authHandler initiatePasswordRecoveryForEmail:emailField.text];
}

- (IBAction)join:(id)sender
{
    NSLog(@"signInViewController join");
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.authHandler updateUserName:nameField.text];
}

- (IBAction)toggleSignInOrPasswordRecoveryForm:(id)sender {
    if (passwordField.isEnabled) {
        [passwordField setEnabled:NO];
        [passwordField setHidden:YES];
        [signInButton setTitle:@"RECOVER PASSWORD" forState:UIControlStateNormal];
        [forgotPasswordButton setTitle:@"I remember my password." forState:UIControlStateNormal];
    } else {
        [passwordField setEnabled:YES];
        [passwordField setHidden:NO];
        [signInButton setTitle:@"SIGN UP OR SIGN IN" forState:UIControlStateNormal];
        [forgotPasswordButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    }
}

- (IBAction)showTermsOfService:(id)sender {
    // modally show the web view controller
    [self presentViewController:_webViewController animated:YES completion:nil];
    _webViewController.viewType = kViewTypeOK;
    [_webViewController loadURL:@"https://www.cine.io/legal/terms-of-service"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == passwordField) {
        [self signInOrSignUpOrRecoverPassword:textField];
    } else if (textField == nameField) {
        [self join:textField];
    }

    return YES;
}
@end
