//
//  ARErrorDomain.h
//
//  Created by Axel Rivera on 8/24/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const DigitalOceanErrorDomain;

@interface ARErrorDomain : NSObject

// Required Override
+ (NSString *)domain;
- (NSString *)domain;

+ (NSError *)errorWithCode:(NSInteger)code;
+ (NSError *)errorWithCode:(NSInteger)code errorString:(NSString *)errorString;
+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

@end
