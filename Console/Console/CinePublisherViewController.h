//
//  CinePublisherViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <cineio/CineIO.h>

@interface CinePublisherViewController : CineBroadcasterViewController

@property (weak, nonatomic) CineStream *stream;

@end
