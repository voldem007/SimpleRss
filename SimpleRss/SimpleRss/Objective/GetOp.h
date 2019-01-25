//
//  GetOp.h
//  SimpleRss
//
//  Created by Voldem on 1/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GetOp : NSOperation {
    BOOL        executing;
    BOOL        finished;
    NSURL *url;
}

@property (nullable, copy) void (^getCompletionHandler)(UIImage *image);

- (id)initWithURL:(NSURL*) imageUrl;
@end
