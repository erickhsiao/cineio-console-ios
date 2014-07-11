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
    NSLog(@"signInGithub");
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

@end
