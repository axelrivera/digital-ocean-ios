//
//  ARErrorDomain.m
//
//  Created by Axel Rivera on 8/24/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "ARErrorDomain.h"

NSString * const DigitalOceanErrorDomain = @"com.riveralabs.digitalocean.error";

@implementation ARErrorDomain

+ (NSString *)domain
{
    return DigitalOceanErrorDomain;
}

- (NSString *)domain
{
    return [[self class] domain];
}

+ (NSError *)errorWithCode:(NSInteger)code
{
    return [NSError errorWithDomain:[[self class] domain] code:code userInfo:nil];
}

+ (NSError *)errorWithCode:(NSInteger)code errorString:(NSString *)errorString
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorString };
    return [NSError errorWithDomain:[[self class] domain] code:code userInfo:userInfo];
}

+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:[[self class] domain] code:code userInfo:userInfo];
}

@end
