//
//  CineSignInViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineSignInViewController.h"
#import "CineWebViewController.h"

@interface CineSignInViewController ()

@end

@implementation CineSignInViewController

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

- (IBAction)showForgotPasswordForm:(id)sender {
    NSLog(@"showForgotPasswordForm");
}

- (IBAction)showTermsOfService:(id)sender {
    NSLog(@"showTermsOfService");

    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    UIStoryboard *storyboard = window.rootViewController.storyboard;
    CineWebViewController *webViewController = (CineWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"webScreen"];
    [self presentViewController:webViewController animated:YES completion:nil];
    // TODO: use API to get static document
    [webViewController showURL:@"https://www.cine.io/legal/terms-of-service"];
}

@end
