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
@synthesize spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Player";

    [spinner startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self attemptToPlayStream];
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(void)attemptToPlayStream
{
    NSInteger statusCode = 0;
    NSInteger numTries = 0;
    while (statusCode != 200 && numTries < 3) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:stream.playUrlHLS]];
        NSHTTPURLResponse *res = nil;
        NSError *err = nil;
        [NSURLConnection sendSynchronousRequest:req
                              returningResponse:&res
                                          error:&err];
        statusCode = res.statusCode;
        numTries++;
        NSLog(@"statusCode = %d", statusCode);
        [NSThread sleepForTimeInterval:1.0];
    }
    if (statusCode == 200) {
        [self startStreaming];
    } else {
        [spinner stopAnimating];
        [self closeModal];
    }
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
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerScalingModeDidChangeNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMovieSourceTypeAvailableNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchAll:)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:_moviePlayer];
    
    _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void)catchAll:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    NSLog(@"%@", notification);
    NSLog(@"%ld", (long)[player movieSourceType]);
    NSLog(@"%@", [player contentURL]);
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
    [self closeModal];
}

- (void)closeModal
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
