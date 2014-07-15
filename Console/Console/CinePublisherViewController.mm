//
//  CinePublisherViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CinePublisherViewController.h"
#import <cineio/CineIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CinePublisherViewController ()

@end

@implementation CinePublisherViewController

// CineBroadcasterProtocol
@synthesize frameWidth;
@synthesize frameHeight;
@synthesize framesPerSecond;
@synthesize videoBitRate;
@synthesize numAudioChannels;
@synthesize sampleRateInHz;

@synthesize publishUrl;
@synthesize publishStreamName;

@synthesize stream;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Publisher";

    //-- A/V setup
    self.frameWidth = 1280;
    self.frameHeight = 720;
    self.framesPerSecond = 30;
    self.videoBitRate = 1500000;
    self.numAudioChannels = 2;
    self.sampleRateInHz = 44100;

    //-- cine.io setup
    self.publishUrl = stream.publishUrl;
    self.publishStreamName = stream.publishStreamName;
    
    // once we've fully-configured our properties, we can enable the
    // UI controls on our view
    [self enableControls];
}

@end