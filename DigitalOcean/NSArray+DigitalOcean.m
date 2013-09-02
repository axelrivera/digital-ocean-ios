//
//  NSArray+DigitalOcean.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "NSArray+DigitalOcean.h"

@implementation NSArray (DigitalOcean)

- (NSDictionary *)dictionaryWithIDKey
{
    __block NSMutableDictionary *dictionary = [@{} mutableCopy];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(objectIDString)]) {
            NSString *idStr = [obj objectIDString];
            [dictionary setObject:obj forKey:idStr];
        }
    }];
    return dictionary;
}

@end
