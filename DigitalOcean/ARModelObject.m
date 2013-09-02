//
//  ARModelObject.m
//
//  Created by Axel Rivera on 8/30/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "ARModelObject.h"

@implementation ARModelObject

+ (id)instanceWithDictionary:(NSDictionary *)dictionary
{
    id object = [[[self class] alloc] initWithDictionary:dictionary];
    return object;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    // Should override in subclass
    return nil;
}

@end

// Helper Category to extract and convert objects from a JSON NSDictionary

@implementation NSDictionary (ARModelObject)

- (NSArray *)extractArrayObjectsForKey:(NSString *)key objectClass:(NSString *)classString
{
    if (![self isKindOfClass:[NSDictionary class]]) {
        DLog(@"Extracting Object is Not a Dictionary")
        return @[];
    }

    NSArray *rawObjects = [self[key] isKindOfClass:[NSArray class]] ? self[key] : @[];
    NSMutableArray *objects = [@[] mutableCopy];

    Class objectClass = NSClassFromString(classString);

    for (id dictionary in rawObjects) {
        if ([objectClass respondsToSelector:@selector(instanceWithDictionary:)]) {
            id object = [objectClass instanceWithDictionary:dictionary];
            [objects addObject:object];
        }
    }

    return objects;
}

- (id)extractObjectForKey:(NSString *)key objectClass:(NSString *)classString
{
    if (![self isKindOfClass:[NSDictionary class]]) {
        DLog(@"Extracting Object is Not a Dictionary")
        return nil;
    }

    Class objectClass = NSClassFromString(classString);

    NSDictionary *rawObject = self[key];
    id object = nil;
    if (rawObject) {
        if ([objectClass respondsToSelector:@selector(instanceWithDictionary:)]) {
            object = [objectClass instanceWithDictionary:rawObject];
        }
    }
    return object;
}

- (id)extractObjectValueForKey:(NSString *)key objectClass:(NSString *)objectClass
{
    if (![self isKindOfClass:[NSDictionary class]]) {
        DLog(@"Extracting Object is Not a Dictionary")
        return nil;
    }
    
    id object = self[key];
    if (![object isKindOfClass:NSClassFromString(objectClass)]) {
        object = nil;
    }
    
    return object;
}

- (NSString *)extractStringValueForKey:(NSString *)key
{
    return [self extractObjectValueForKey:key objectClass:NSStringFromClass([NSString class])];
}

- (NSInteger)extractIntegerValueForKey:(NSString *)key
{
    return [[self extractObjectValueForKey:key objectClass:NSStringFromClass([NSNumber class])] integerValue];
}

- (CGFloat)extractFloatValueForKey:(NSString *)key
{
    return [[self extractObjectForKey:key objectClass:NSStringFromClass([NSNumber class])] floatValue];
}

- (BOOL)extractBoolValueForKey:(NSString *)key
{
    return [[self extractObjectValueForKey:key objectClass:NSStringFromClass([NSNumber class])] boolValue];
}

@end
