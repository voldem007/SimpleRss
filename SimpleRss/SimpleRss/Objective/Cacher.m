//
//  Cacher.m
//  SimpleRss
//
//  Created by Voldem on 1/21/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "Cacher.h"
#import "GetOp.h"
#import <Foundation/Foundation.h>

@implementation Cacher

NSOperationQueue *operationQueue;
int expiredDays;
NSURL *imagesDirectoryURL;

- (id)initWithURL:(NSURL *)imagesDirectory expiredDate:(int)expiredDate {
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    
    imagesDirectoryURL = imagesDirectory;
    expiredDays = expiredDate;
    
    [self createIfEmptyCacheImageDirectory];
    [self deleteInnerExpiredFiles];
    
    return self;
}

- (void)deleteInnerExpiredFiles {
    NSArray<NSURL *> * urls = [self getContents: imagesDirectoryURL];
    NSArray<NSURL *> * urlsForDelete = [self findExpiredURLs: urls];
    [self deleteExpiredFiles: urlsForDelete];
}

- (GetOp *)get:(NSURL *)url {
    NSURL *fileUrl = [imagesDirectoryURL URLByAppendingPathComponent:(url.lastPathComponent)];
    GetOp *getOp = [[GetOp alloc] initWithURL: fileUrl];
    [operationQueue addOperation:getOp];
    return getOp;
}

- (void)save:(NSURL *) url image:(UIImage *)image {
    NSURL *fileUrl = [imagesDirectoryURL URLByAppendingPathComponent:(url.lastPathComponent)];
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock: ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        if (![NSFileManager.defaultManager fileExistsAtPath:fileUrl.absoluteString]) {
            [data writeToURL:fileUrl atomically:true];
        }
    }];
    [operationQueue addOperation:blockOp];
}

- (NSArray<NSURL *> *)getContents:(NSURL *) url {
    return [NSFileManager.defaultManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
}

- (void)createIfEmptyCacheImageDirectory {
    if (![NSFileManager.defaultManager fileExistsAtPath:imagesDirectoryURL.path]) {
        [NSFileManager.defaultManager createDirectoryAtURL:imagesDirectoryURL withIntermediateDirectories:false attributes:nil error:nil];
    }
}

- (void)deleteExpiredFiles:(NSArray<NSURL *> *) urlsForDelete {
    for (NSURL *url in urlsForDelete) {
       if (![NSFileManager.defaultManager fileExistsAtPath:url.absoluteString]) {
           NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock: ^{
               [NSFileManager.defaultManager removeItemAtURL:url error:nil];
           }];
           blockOp.qualityOfService = NSQualityOfServiceBackground;
           [operationQueue addOperation:blockOp];
        }
    }
}

- (NSArray<NSURL *> *)findExpiredURLs:(NSArray<NSURL *> *) urls {
    NSMutableArray<NSURL *> * expiredURLs = [[NSMutableArray alloc] init];
    for (NSURL *url in urls) {
        NSDictionary<NSURLResourceKey, id> *values =[url resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil];
        NSDate *fileDate = values[NSURLCreationDateKey];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -expiredDays;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

        NSComparisonResult result = [nextDate compare:fileDate];
        
        if(result==NSOrderedDescending) {
            [expiredURLs addObject:url];
        }
    }
    return expiredURLs;
}

@end
