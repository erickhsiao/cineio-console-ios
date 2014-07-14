//
//  CineStreamViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineStreamViewController.h"

@interface CineStreamViewController ()
{
    enum CineStreamViewSection {
        kSectionGeneral = 0,
        kSectionPlayback = 1,
        kSectionPublish = 2
    };
}
@end

@implementation CineStreamViewController

@synthesize stream;

@synthesize playButton;
@synthesize publishButton;
@synthesize deleteButton;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case kSectionGeneral:
            return 2;
        case kSectionPlayback:
            return 2;
        case kSectionPublish:
            return 2;
    }
    return 0;
}

- (void)setCellContents:(UITableViewCell *)cell withName:(NSString *)name andValue:(NSString*)value
{
    ((UILabel *)cell.contentView.subviews[0]).text = name;
    ((UILabel *)cell.contentView.subviews[1]).text = value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StreamAttrCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch(indexPath.section) {
        case kSectionGeneral:
        {
            if (indexPath.row == 0) {
                [self setCellContents:cell withName:@"Id:" andValue:stream.streamId];
            } else if (indexPath.row == 1) {
                [self setCellContents:cell withName:@"Name:" andValue:stream.name];
            }
        }
            break;
        case kSectionPlayback:
        {
            if (indexPath.row == 0) {
                [self setCellContents:cell withName:@"RTMP:" andValue:stream.playUrlRTMP];
            } else if (indexPath.row == 1) {
                [self setCellContents:cell withName:@"HLS:" andValue:stream.playUrlHLS];
            }
        }
            break;
        case kSectionPublish:
        {
            if (indexPath.row == 0) {
                [self setCellContents:cell withName:@"URL:" andValue:stream.publishUrl];
            } else if (indexPath.row == 1) {
                [self setCellContents:cell withName:@"Stream:" andValue:stream.publishStreamName];
            }
        }
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section) {
        case kSectionGeneral:
            return @"General";
        case kSectionPlayback:
            return @"Playback";
        case kSectionPublish:
            return @"Publishing";
    }
    return @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
