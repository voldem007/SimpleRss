//
//  GetOp.m
//  SimpleRss
//
//  Created by Voldem on 1/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "GetOp.h"
#import <Foundation/Foundation.h>

@implementation GetOp

@synthesize getCompletionHandler;

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
    UIImage *image = nil;
    @try {
        if ([NSFileManager.defaultManager fileExistsAtPath:url.path]) {
            image = [UIImage imageWithContentsOfFile:url.path];
        }
        getCompletionHandler(image);
        
        [self completeOperation];
    }
    @catch(...) {
        getCompletionHandler(nil);
        
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
