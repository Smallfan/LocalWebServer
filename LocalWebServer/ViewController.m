//
//  ViewController.m
//  LocalWebServer
//
//  Created by Smallfan on 23/08/2017.
//  Copyright © 2017 Smallfan. All rights reserved.
//
//
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "LocalWebServerManager.h"

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>
{
    WKWebView *_wkWebView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
    
    //Start local web server
    [[LocalWebServerManager sharedInstance] start];
    
    //Local request which use local resource
    [self loadLocalRequest];
    
    //Remote request which use local resource
//    [self loadRemoteRequest];
    
}

- (void)setupWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        configuration.userContentController = controller;
        configuration.processPool = [[WKProcessPool alloc] init];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                        configuration:configuration];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        [self.view addSubview:_wkWebView];
    }
}

- (void)loadRemoteRequest {
    if (_wkWebView) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://smallfan.net/demo.html"]]];
    }
}

- (void)loadLocalRequest {
    if (_wkWebView) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://localhost:%ld/index.html", [[LocalWebServerManager sharedInstance] port] ] ]]];
    }
}

#pragma mark - WKNavigationDelegate
-                   (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
                completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

#pragma mark - UIDelegate
-                       (void)webView:(WKWebView *)webView
   runJavaScriptAlertPanelWithMessage:(NSString *)message
                     initiatedByFrame:(WKFrameInfo *)frame
                    completionHandler:(void (^)(void))completionHandler {
    
    NSString *alertTitle = @"温馨提示";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
