//
//  DORegion.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DORegion.h"

@implementation DORegion

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.objectID = [dictionary[@"id"] integerValue];
        _name = [dictionary[@"name"] copy];
    }
    return self;
}

@end
