//
//  Downloader.m
//  SimpleRss
//
//  Created by Voldem on 1/20/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "Downloader.h"
#import "DownloadOp.h"
#import <Foundation/Foundation.h>

@implementation Downloader

NSOperationQueue *operationQueue;

- (id)initWithMaxOperations:(int) count {
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:count];
    return self;
}

- (DownloadOp *)download:(NSURL *)url {
    DownloadOp* theOp = [[DownloadOp alloc] initWithURL: url];
    [operationQueue addOperation:theOp];
    return theOp;
}

@end
