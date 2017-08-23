//
//  LocalWebServerManager.m
//  LocalWebServer
//
//  Created by Smallfan on 23/08/2017.
//  Copyright © 2017 Smallfan. All rights reserved.
//

#import "LocalWebServerManager.h"

#import "HTTPServer.h"
#import "MyHTTPConnection.h"

@interface LocalWebServerManager ()
{
    HTTPServer *_httpServer;
}
@end

@implementation LocalWebServerManager

+ (instancetype)sharedInstance {
    static LocalWebServerManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocalWebServerManager alloc] init];
    });
    return _sharedInstance;
}

- (void)start {
    
    _port = 60000;
    
    if (!_httpServer) {
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setConnectionClass:[MyHTTPConnection class]];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:_port];
        NSString * webLocalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
        [_httpServer setDocumentRoot:webLocalPath];
        
        NSLog(@"Setting document root: %@", webLocalPath);
        
    }
    
    if (_httpServer && ![_httpServer isRunning]) {
        NSError *error;
        if([_httpServer start:&error]) {
            NSLog(@"start server success in port %d %@", [_httpServer listeningPort], [_httpServer publishedName]);
        } else {
            NSLog(@"启动失败");
        }
    }
    
}

- (void)stop {
    if (_httpServer && [_httpServer isRunning]) {
        [_httpServer stop];
    }
}

@end
