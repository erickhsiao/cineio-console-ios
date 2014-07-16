//
//  CineWebViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineWebViewController.h"
#import "AFNetworking.h"
#import "NSURL+QueryParser.h"

@interface CineWebViewController () <UIWebViewDelegate>
{
    UIColor *_turquoiseColor;
}

@end

@implementation CineWebViewController

@synthesize webView;
@synthesize closeButton;
@synthesize viewType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (ViewType)getViewType
{
    NSLog(@"button color: %@", closeButton.backgroundColor);
    if ([closeButton.titleLabel.text isEqualToString:@"OK"]) {
        return kViewTypeOK;
    } else {
        return kViewTypeCancel;
    }
}

- (void)setViewType:(ViewType)newViewType
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    if (newViewType == kViewTypeOK) {
        [closeButton setTitle:@"OK" forState:UIControlStateNormal];
        closeButton.backgroundColor = _turquoiseColor;
    } else {
        [closeButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        closeButton.backgroundColor = [UIColor redColor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    _turquoiseColor = [UIColor colorWithRed:0.089534 green:0.481209 blue:0.454555 alpha:1.0];
}

- (void)loadURL:(NSString *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:req];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Optional UIWebViewDelegate delegate methods

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // special handling for cine.io legal documents
    if ([[request URL].absoluteString hasPrefix:@"https://www.cine.io/legal"]) {
        // get the static document via the API and load it
        NSString *path = [request URL].path;
        NSLog(@"Loading: %@", path);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *apiStaticUrl = [NSString stringWithFormat:@"https://www.cine.io/api/1/-/static-document?id=%@", path];
        [manager GET:apiStaticUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
            [theWebView loadHTMLString:response[@"document"] baseURL:[NSURL URLWithString:@"https://www.cine.io/"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [theWebView loadHTMLString:[error localizedDescription] baseURL:nil];
        }];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"requesting URL: %@", theWebView.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"loaded URL: %@", theWebView.request.URL.absoluteString);
}

- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"failed to load URL: %@ (%@)", theWebView.request.URL.absoluteString, error);
}

@end
