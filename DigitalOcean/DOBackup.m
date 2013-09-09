//
//  DOBackgup.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DOBackup.h"

@implementation DOBackup

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.objectID = [dictionary[@"id"] integerValue];
        _name = [dictionary[@"name"] copy];
        _distribution = [dictionary[@"distribution"] copy];
    }
    return self;
}

@end
