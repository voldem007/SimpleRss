//
//  DownloadOp.m
//  SimpleRss
//
//  Created by Voldem on 1/21/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "DownloadOp.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation DownloadOp

@synthesize downloadCompletionHandler;

- (id)initWithURL:(NSURL*) imageUrl {
    self = [super init];
    if (self) {
        url = imageUrl;
        executing = NO;
        finished = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start {
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL: url]];
        downloadCompletionHandler(image, url);
        [self completeOperation];
    }
    @catch(...) {
        [self completeOperation];
    }
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
