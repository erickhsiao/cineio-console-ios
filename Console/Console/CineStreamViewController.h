//
//  CineStreamViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cineio/CineIO.h"

@interface CineStreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) CineStream *stream;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
