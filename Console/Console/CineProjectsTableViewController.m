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
#import "CineStreamsTableViewController.h"
#import "CineAccount.h"
#import "cineio/CineIO.h"

@interface CineProjectsTableViewController () <UIAlertViewDelegate>

@end

@implementation CineProjectsTableViewController

@synthesize account;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadProjects];
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
    NSString *headerTitle = (account && account.name) ? account.name : @"Please wait ...";
    return headerTitle;
}

#pragma mark - Data loaders

- (void)loadProjects
{
    CineClient *cine = [[CineClient alloc] init];
    cine.masterKey = account.masterKey;
    [cine getProjectsWithCompletionHandler:^(NSError *err, NSArray *loadedProjects) {
        projects = [[NSMutableArray alloc] initWithArray:loadedProjects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"showStreamsForProject"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CineStreamsTableViewController *streamsViewController = segue.destinationViewController;
        streamsViewController.project = [projects objectAtIndex:indexPath.row];
    }
}

@end
