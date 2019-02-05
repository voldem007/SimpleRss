//
//  DownloadOp.h
//  SimpleRss
//
//  Created by Voldem on 1/21/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadOp : NSOperation {
    BOOL        executing;
    BOOL        finished;
    UIImage *image;
    NSURL *url;
}

@property (nullable, copy) void (^downloadCompletionHandler)(UIImage *image, NSURL *url);

- (id)initWithURL:(NSURL*) imageUrl;

@end
