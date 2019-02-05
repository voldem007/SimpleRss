//
//  Downloader.h
//  SimpleRss
//
//  Created by Voldem on 1/20/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

#import "DownloadOp.h"
#import <Foundation/Foundation.h>

@interface Downloader : NSObject

- (id)initWithMaxOperations:(int) count;

- (DownloadOp *)download:(NSURL *)url;

@end

