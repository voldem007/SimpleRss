//
//  Orchestrator.m
//  SimpleRss
//
//  Created by Voldem on 1/24/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "Orchestrator.h"
#import "GetOp.h"
#import "FileCache.h"
#import "Manager.h"
#import <Foundation/Foundation.h>

@implementation Orchestrator

Manager *downloadManager;
FileCache *imageCache;

- (id)init {
    downloadManager = [[Manager alloc] init];
    imageCache = [[FileCache alloc] init];
    return self;
}

- (GetOp *)download:(NSURL *)url completion:(void (^)(UIImage *image))completion {
    GetOp *getOp = [imageCache get:url];
    getOp.getCompletionHandler = ^(UIImage *image) {
        //if(getOp.isCancelled) return;
        if(image != nil) {
            completion(image);
        } else {
            DownloadOp *op = [downloadManager download:url];
            //[getOp addDependency:op];
            op.downloadCompletionHandler = ^(UIImage *image, NSURL *url) {
                //if(op.isCancelled) return;
                completion(image);
                if(image != nil) {
                    [imageCache save:url image:image];
                }
            };
        }
    };
    return getOp;
}

- (void)cancel:(NSOperation *)op {
    [op cancel];
    NSArray<NSOperation *> *dependencies = [op dependencies];
    for (NSOperation *operation in dependencies) {
        [operation cancel];
    }
}

@end
