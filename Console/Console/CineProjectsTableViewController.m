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

@interface CineProjectsTableViewController ()

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadProjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"%@", error);
    }];
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
