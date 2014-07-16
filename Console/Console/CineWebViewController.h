//
//  CineWebViewController.h
//  Console
//
//  Created by Jeffrey Wescott on 7/10/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CineWebViewController : UIViewController

enum ViewType {
    kViewTypeOK,
    kViewTypeCancel
};

@property (nonatomic, getter=getViewType, setter=setViewType:) ViewType viewType;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadURL:(NSString*)url;
- (IBAction)dismiss:(id)sender;

@end
