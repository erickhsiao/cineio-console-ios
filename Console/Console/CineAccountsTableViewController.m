//
//  CineAccountsTableViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 8/20/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineAccountsTableViewController.h"
#import "CineAppDelegate.h"
#import "CineProjectsTableViewController.h"
#import "CineAccount.h"

@interface CineProjectsTableViewController () <UIAlertViewDelegate>

@end

@implementation CineAccountsTableViewController

@synthesize user;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Accounts";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignIn:)
                                                 name:@"SignInSuccess"
                                               object:nil];
    
    // REALLY!?!?! 8 fucking lines to add a sign-out button!?
    UIImage *signOutImage = [UIImage imageNamed:@"sign-out"];
    CGRect signOutImageFrame = CGRectMake(0, 0, signOutImage.size.width, signOutImage.size.height);
    UIButton* signOutButton = [[UIButton alloc] initWithFrame:signOutImageFrame];
    [signOutButton setBackgroundImage:signOutImage forState:UIControlStateNormal];
    [signOutButton setShowsTouchWhenHighlighted:YES];
    [signOutButton addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* signOutNavItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];
    [self.navigationItem setLeftBarButtonItem:signOutNavItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadAccounts];
}

- (void)didSignIn:(NSNotification *)notification
{
    NSLog(@"accountsViewController didSignIn");
    user = (CineUser *)[notification userInfo][@"user"];
    [self.tableView reloadData];
}

- (void)signOut
{
    UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Sign out?"
                                                      message:@"Are you sure you want to sign out?"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:@"Cancel", nil];
    [confirm show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"signing out");
        CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.authHandler signOut];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return user.accounts ? [user.accounts count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CineAccount *account = [user.accounts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = account.name ? account.name : [NSString stringWithFormat:@"Account %d", indexPath.row+1];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = user ? ((user.name && user.name.length) ? user.name : user.email) : @"Please wait ...";
    return headerTitle;
}

#pragma mark - Data loaders

- (void)loadAccounts
{
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.signedIn) {
        user = appDelegate.user;
        [self.tableView reloadData];
    } else {
        NSLog(@"Can't load accounts. User is not yet signed-in.");
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProjectsForAccount"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CineProjectsTableViewController *projectsViewController = segue.destinationViewController;
        projectsViewController.account = [user.accounts objectAtIndex:indexPath.row];
    }
}

@end
