//
//  Cache.h
//  SimpleRss
//
//  Created by Voldem on 1/21/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "GetOp.h"
#import <Foundation/Foundation.h>

@interface FileCache : NSObject

- (void)save:(NSURL *) url image:(UIImage *)image;
- (GetOp *)get:(NSURL *)url;

@end
