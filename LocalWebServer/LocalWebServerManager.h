//
//  LocalWebServerManager.h
//  LocalWebServer
//
//  Created by Smallfan on 23/08/2017.
//  Copyright © 2017 Smallfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalWebServerManager : NSObject

@property (nonatomic, assign, readonly) NSUInteger port;

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
