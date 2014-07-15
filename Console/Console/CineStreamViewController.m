//
//  CineStreamViewController.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineStreamViewController.h"
#import "CineStreamerViewController.h"
#import "CinePublisherViewController.h"
#import "CineNavigationViewController.h"

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
    
    self.navigationItem.title = stream.name ? stream.name : stream.streamId;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"playStream"]) {
        CineStreamerViewController *streamerViewController = segue.destinationViewController;
        streamerViewController.stream = stream;
    } else if ([segue.identifier isEqualToString:@"publishStream"]) {
        CinePublisherViewController *publisherViewController = segue.destinationViewController;
        publisherViewController.stream = stream;
    }
}

@end
