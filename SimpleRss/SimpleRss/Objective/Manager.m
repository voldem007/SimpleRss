//
//  Manager.m
//  SimpleRss
//
//  Created by Voldem on 1/20/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "Manager.h"
#import "DownloadOp.h"
#import <Foundation/Foundation.h>

@implementation Manager
    NSOperationQueue *operationQueue;

    - (id)init {
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:5];
        return self;
    }

    - (DownloadOp *)download:(NSURL *)url {
        DownloadOp* theOp = [[DownloadOp alloc] initWithURL: url];
        [operationQueue addOperation:theOp];
        return theOp;
    }

@end
