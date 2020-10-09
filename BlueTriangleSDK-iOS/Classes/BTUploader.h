//
//  BTUploader.h
//  BlueTriangle
//
//  Created by Julian Wilkison-Duran on 10/09/2020.
//  Copyright (c) 2020 Blue Triangle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTTimer;

@interface BTUploader : NSObject

- (instancetype)initWithURL:(NSURL *)url;
- (void)upload:(BTTimer *)timer;

@end
