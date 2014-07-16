//
//  CineWebViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineWebViewController.h"

@interface CineWebViewController ()
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
    _turquoiseColor = [UIColor colorWithRed:0.089534 green:0.481209 blue:0.454555 alpha:1.0];
}

- (void)presentHTML:(NSString *)html
{
    [webView loadHTMLString:html baseURL:[NSURL URLWithString:@"https://www.cine.io/"]];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
