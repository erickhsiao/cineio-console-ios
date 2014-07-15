//
//  CinePlayerViewController.h
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <cineio/CineIO.h>

@interface CinePlayerViewController : UIViewController

@property (weak, nonatomic) CineStream *stream;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)startStreaming;

@end
