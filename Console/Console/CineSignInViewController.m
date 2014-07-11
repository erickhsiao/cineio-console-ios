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

@end

@implementation CineSignInViewController

@synthesize signInView;
@synthesize activityIndicatorView;
@synthesize statusLabel;
@synthesize emailField;
@synthesize passwordField;
@synthesize signInButton;
@synthesize forgotPasswordButton;

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
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)submitForm:(id)sender {
    [self setBusy:YES];
    if (passwordField.isEnabled) {
        [self signInOrSignUp];
    } else {
        [self recoverPassword];
    }
}

- (IBAction)signInGithub:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"GitHub"];
}

- (IBAction)toggleForm:(id)sender {
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
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    UIStoryboard *storyboard = window.rootViewController.storyboard;
    CineWebViewController *webViewController = (CineWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"webScreen"];
    [self presentViewController:webViewController animated:YES completion:nil];
    
    // load the TOS into it
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.cine.io/api/1/-/static-document?id=legal%2Fterms-of-service" parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
        [webViewController presentHTML:response[@"document"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [webViewController presentHTML:[error localizedDescription]];
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

#pragma Sign-in / Sign-up stuff

- (void)signInOrSignUp
{
    NSLog(@"sign up / sign in");
    NSDictionary *formData =
    @{ @"username": emailField.text,
       @"password": passwordField.text,
       @"plan": @"free" };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/login" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        CineUser *user = [appDelegate signIn:response];
        NSLog(@"%@ logged in", user.email);
        [self setBusy:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma GitHub OAuth stuff

- (void)initGithubOAuth
{
    NSDictionary *gitHubConfigDict =
        @{ kNXOAuth2AccountStoreConfigurationClientID: @"d672e68c08a4e108b562",
           kNXOAuth2AccountStoreConfigurationSecret: @"7fc58f25f68ecda810b1fa9b293e99fda65d6b39",
           kNXOAuth2AccountStoreConfigurationScope: [NSSet setWithObjects:@"user:email", nil],
           kNXOAuth2AccountStoreConfigurationAuthorizeURL: [NSURL URLWithString:@"https://github.com/login/oauth/authorize"],
           kNXOAuth2AccountStoreConfigurationTokenURL: [NSURL URLWithString:@"https://github.com/login/oauth/access_token"],
           kNXOAuth2AccountStoreConfigurationRedirectURL: [NSURL URLWithString:@"cineioconsole://github-callback"],
           kNXOAuth2AccountStoreConfigurationTokenType: @"Bearer" };
    
    [[NXOAuth2AccountStore sharedStore] setConfiguration:gitHubConfigDict forAccountType:@"GitHub"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      // GitHub sign-in succeeded
                                                      NXOAuth2Account *account = aNotification.userInfo[NXOAuth2AccountStoreNewAccountUserInfoKey];
                                                      
                                                      [self handleGithubSignInSuccess:account];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      NSLog(@"%@", error);
                                                      statusLabel.text = [NSString stringWithFormat:@"ERROR: %@", [error localizedDescription]];
                                                  }];
}

- (void)handleGithubCallback:(NSURL *)url
{
    // handle on our side
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
    
    // TODO: authenticate with cine
    NSDictionary *formData = @{ @"code": [url parseQuery][@"code"],
                                @"state": @"{\"plan\":\"free\"}" };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.cine.io/auth/github/callback" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        [self setBusy:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self setBusy:NO];
    }];
}

- (void)handleGithubSignInSuccess:(NXOAuth2Account *)account
{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"https://api.github.com/user"]
                   usingParameters:nil
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // e.g., update a progress indicator
               }
               responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                   // Process the response
                   NSError* jsonError;
                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:kNilOptions
                                                                          error:&jsonError];
                   NSLog(@"User email: %@", json[@"email"]);
                   [self setBusy:NO];
               }];
}

@end
