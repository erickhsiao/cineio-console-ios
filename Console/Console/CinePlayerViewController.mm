//
//  CinePlayerViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CinePlayerViewController.h"
#import <cineio/CineIO.h>

@interface CinePlayerViewController ()

@end

@implementation CinePlayerViewController

@synthesize stream;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startStreaming];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)startStreaming
{
    NSLog(@"about to play: %@", stream.playUrlHLS);
    NSURL *url = [NSURL URLWithString:stream.playUrlHLS];
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void)stoppedStreaming:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
}

@end
