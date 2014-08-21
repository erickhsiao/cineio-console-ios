//
//  CineProjectsTableViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineAccount.h"

@interface CineProjectsTableViewController : UITableViewController

@property (strong, nonatomic) CineAccount *account;
@property (strong, nonatomic) NSMutableArray *projects;

@end
