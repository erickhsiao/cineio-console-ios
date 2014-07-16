//
//  CineProjectsTableViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineProjectsTableViewController.h"
#import "cineio/CineIO.h"
#import "CineAppDelegate.h"
#import "CineProjectsTableViewController.h"
#import "CineStreamsTableViewController.h"

@interface CineProjectsTableViewController () <UIAlertViewDelegate>

@end

@implementation CineProjectsTableViewController

@synthesize projects;

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
    self.navigationItem.title = @"Projects";
    
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
    [self loadProjects];
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
        [appDelegate signOut];
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
    return projects ? [projects count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CineProject *project = [projects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = project.name ? project.name : project.projectId;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *headerTitle = appDelegate.user ? ((appDelegate.user.name && appDelegate.user.name.length) ? appDelegate.user.name : appDelegate.user.email) : @"Please wait ...";
    return headerTitle;
}

#pragma mark - Data loaders

- (void)loadProjects
{
    CineAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.signedIn) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"https://www.cine.io/api/1/-/projects" parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
            NSArray *projectsJson = response;
            projects = [[NSMutableArray alloc] init];
            for (NSDictionary *attrs in projectsJson) {
                CineProject *project = [[CineProject alloc] initWithAttributes:attrs];
                [projects addObject:project];
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error loading projects: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"There was a problem while trying to load your projects."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        NSLog(@"Can't load projects. User is not yet signed-in.");
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStreamsForProject"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CineStreamsTableViewController *streamsViewController = segue.destinationViewController;
        streamsViewController.project = [projects objectAtIndex:indexPath.row];
    }
}

@end
