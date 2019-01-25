//
//  Orchestrator.h
//  SimpleRss
//
//  Created by Voldem on 1/24/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//
#import "GetOp.h"
#import <Foundation/Foundation.h>

@interface Orchestrator : NSObject

+ (Orchestrator *)sharedInstance;


- (GetOp *)download:(NSURL *) url completion:(void (^)(UIImage *image))completion;
- (void)cancel:(NSOperation *)op;

@end
