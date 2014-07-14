//
//  CineStreamsTableViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineStreamsTableViewController.h"
#import "CineStreamViewController.h"
#import "cineio/CineIO.h"

@interface CineStreamsTableViewController ()

@end

@implementation CineStreamsTableViewController

@synthesize project;
@synthesize streams;

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

    [self loadStreams];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadStreams];
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
    return streams ? [streams count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StreamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CineStream *stream = [streams objectAtIndex:indexPath.row];
    
    cell.textLabel.text = stream.name ? stream.name : stream.streamId;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return project.name;
}

#pragma mark - Data loaders

- (void)loadStreams
{
    CineClient *cine = [[CineClient alloc] initWithSecretKey:project.secretKey];
    [cine getStreamsWithCompletionHandler:^(NSError *err, NSArray *loadedStreams) {
        streams = [[NSMutableArray alloc] initWithArray:loadedStreams];
        [self.tableView reloadData];        
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"showStreamDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CineStreamViewController *streamViewController = segue.destinationViewController;
        streamViewController.stream = [streams objectAtIndex:indexPath.row];
    }
}

@end
