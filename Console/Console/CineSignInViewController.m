//
//  CineSignInViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineSignInViewController.h"
#import "CineWebViewController.h"
#import "AFNetworking.h"


@interface CineSignInViewController ()

@end

@implementation CineSignInViewController

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

- (IBAction)signIn:(id)sender {
    NSLog(@"signIn");
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
                                                      // GitHub sign-in failed
                                                      NSLog(@"%@", error);
                                                  }];
}

- (void)handleGithubCallback:(NSURL *)url
{
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
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
               }];
}

@end
