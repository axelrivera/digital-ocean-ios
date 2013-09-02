//
//  RJError.h
//  RamaJudicial
//
//  Created by Axel Rivera on 8/24/13.
//  Copyright (c) 2013 Polsense, Inc. All rights reserved.
//

#import "ARErrorDomain.h"

typedef NS_ENUM(NSInteger, ARErrorCode) {
    ARErrorCode_Error = 0
};

@interface ARError : ARErrorDomain

+ (NSError *)error;

@end