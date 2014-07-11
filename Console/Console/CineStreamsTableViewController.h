//
//  CineStreamsTableViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cineio/CineIO.h"

@interface CineStreamsTableViewController : UITableViewController

@property (weak, nonatomic) CineProject *project;
@property (strong, nonatomic) NSMutableArray *streams;

@end
