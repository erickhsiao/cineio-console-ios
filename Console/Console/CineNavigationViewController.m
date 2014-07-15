//
//  CineNavigationViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/14/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineNavigationViewController.h"
#import "CinePublisherViewController.h"

@interface CineNavigationViewController ()

@end

@implementation CineNavigationViewController

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
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    if ([self.topViewController isKindOfClass:[CinePublisherViewController class]]) {
        NSLog(@"shouldAutorotate NO");
        return NO;
    }
    NSLog(@"shouldAutorotate YES");
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:[CinePublisherViewController class]]) {
        NSLog(@"supportedInterfaceOrientations portrait");
        return UIInterfaceOrientationMaskPortrait;
    }
    NSLog(@"supportedInterfaceOrientations all");
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
