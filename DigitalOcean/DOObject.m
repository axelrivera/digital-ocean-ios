//
//  DOObject.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DOObject.h"

@implementation DOObject

- (NSString *)objectIDString
{
    return [[NSNumber numberWithInteger:self.objectID] stringValue];
}

#pragma mark - NSObject Protocol Methods

- (BOOL)isEqual:(id)anObject
{
	if (self == anObject) return YES;

	if ([anObject isKindOfClass:[DOObject class]]) {
		NSString *myObjectID = [NSString stringWithFormat:@"%@_%@",
                               NSStringFromClass([self class]), [self objectIDString]];
		NSString *theirObjectID = [NSString stringWithFormat:@"%@_%@",
                                   NSStringFromClass([anObject class]), [anObject objectIDString]];
		return myObjectID && theirObjectID ? [myObjectID isEqualToString:theirObjectID] : NO;
	}
	return NO;
}

- (NSUInteger)hash
{
    NSString *myObjectID = [NSString stringWithFormat:@"%@_%@",
                            NSStringFromClass([self class]), [self objectIDString]];
    return [myObjectID hash];
}

@end
