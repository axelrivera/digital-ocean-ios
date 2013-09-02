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

@end
