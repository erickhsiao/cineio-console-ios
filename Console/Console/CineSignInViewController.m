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
#import "NSURL+QueryParser.h"


@interface CineSignInViewController ()
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
    [self showSignInForm];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

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
}

- (IBAction)signInOrSignUp:(id)sender {
    [self setBusy:YES];
    if (passwordField.isEnabled) {
        [self signIn];
    } else {
        [self recoverPassword];
    }
}

- (IBAction)signInGithub:(id)sender {
    [self setBusy:YES];

    // modally show the web view controller
    [self presentViewController:_webViewController animated:YES completion:nil];
    _webViewController.viewType = kViewTypeCancel;

    // request the Github authentication URL
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:@"https://www.cine.io/auth/github?client=iOS&plan=free"]];
    [_webViewController.webView loadRequest:requestUrl];
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

- (IBAction)join:(id)sender
{
    NSLog(@"join");
    NSDictionary *formData =
    @{ @"name": nameField.text };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/api/1/-/update-account" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.user.name = response[@"name"];
        NSLog(@"user name set to %@ for %@", appDelegate.user.name, appDelegate.user.email);
        [self setBusy:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
        [self setBusy:NO];
    }];
}

#pragma UI stuff

- (void)setBusy:(BOOL)busy
{
    if (busy) {
        statusLabel.text = @"";
        [signInView setUserInteractionEnabled:NO];
        [signInView setHidden:YES];
        [activityIndicatorView startAnimating];
    } else {
        [activityIndicatorView stopAnimating];
        [signInView setHidden:NO];
        [signInView setUserInteractionEnabled:YES];
    }
}

#pragma Sign-in stuff

- (void)signIn
{
    NSLog(@"sign in");
    NSDictionary *formData =
    @{ @"username": emailField.text,
       @"password": passwordField.text,
       @"plan": @"free" };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/login" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        CineUser *user = [appDelegate signIn:response];
        NSLog(@"user name: %@", user.name);
        if (![user.name length]) {
            [self showJoinForm];
        } else {
            NSLog(@"%@ <%@> logged in", user.name, user.email);
            [self setBusy:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
        [self setBusy:NO];
    }];
}

- (void)signOut
{
    // AFNetworking uses standard cookie storage, so to log out, just delete our cookies
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

- (void)recoverPassword
{
    NSLog(@"recover password");
    NSDictionary *formData = @{ @"email": emailField.text };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/api/1/-/password-change-request" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        [self setBusy:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
        [self setBusy:NO];
    }];
}

#pragma URL handlers

- (void)handleLogin:(NSURL *)url
{
    NSDictionary *queryString = @{ @"masterKey": [url parseQuery][@"masterKey"] };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.cine.io/api/1/-/user" parameters:queryString success:^(AFHTTPRequestOperation *operation, id response) {
        
        // sign-in
        CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        CineUser *user = [appDelegate signIn:response];
        NSLog(@"%@ <%@> signed in", user.name, user.email);

        // if the web view controller is open, close it
        if (_webViewController.isViewLoaded && _webViewController.view.window) {
            [_webViewController dismissViewControllerAnimated:YES completion:^{
                [self setBusy:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [self setBusy:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
        [self setBusy:NO];
    }];
}

- (void)handleStaticDocument:(NSURL *)url
{
    NSDictionary *urlParams = [url parseQuery];
    NSLog(@"urlParams: %@", urlParams);
}

@end
