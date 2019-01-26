//
//  Orchestrator.m
//  SimpleRss
//
//  Created by Voldem on 1/24/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "Orchestrator.h"
#import "GetOp.h"
#import "Cacher.h"
#import "Downloader.h"
#import <Foundation/Foundation.h>

@implementation Orchestrator

Downloader *downloadManager;
Cacher *imageCache;

- (id)init {
    
    NSURL *cacheUrl = [NSFileManager.defaultManager URLsForDirectory:NSCachesDirectory
                                       inDomains:NSUserDomainMask].firstObject;
    NSURL *imagesDirectoryURL = [cacheUrl URLByAppendingPathComponent: @"Images"];
    
    imageCache = [[Cacher alloc] initWithURL:imagesDirectoryURL];
    downloadManager = [[Downloader alloc] initWithMaxOperations:5];
    
    return self;
}

+ (Orchestrator *)sharedInstance
{
    static Orchestrator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Orchestrator alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (GetOp *)download:(NSURL *)url completion:(void (^)(UIImage *image))completion {
    GetOp *getOp = [imageCache get:url];
    __weak GetOp *getWeakOperation = getOp;
    getOp.getCompletionHandler = ^(UIImage *image) {
        GetOp *getStrongOperation = getWeakOperation;
        if(getStrongOperation.isCancelled) return;
        if(image != nil) {
            completion(image);
        } else {
            DownloadOp *op = [downloadManager download:url];
            __weak DownloadOp *downloadWeakOperation = op;
            [getStrongOperation addDependency:op];
            op.downloadCompletionHandler = ^(UIImage *image, NSURL *url) {
                DownloadOp *downloadStrongOperation = downloadWeakOperation;
                if(downloadStrongOperation.isCancelled) return;
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
