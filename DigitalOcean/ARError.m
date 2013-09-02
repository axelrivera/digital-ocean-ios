//
//  RJError.m
//  RamaJudicial
//
//  Created by Axel Rivera on 8/24/13.
//  Copyright (c) 2013 Polsense, Inc. All rights reserved.
//

#import "ARError.h"

@implementation ARError

+ (NSError *)error
{
    return [self errorWithCode:ARErrorCode_Error];
}

@end
