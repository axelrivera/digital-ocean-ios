//
//  DODroplet.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DODroplet.h"

@implementation DODroplet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.objectID = [dictionary[@"id"] integerValue];
        
        _name = [dictionary[@"name"] copy];
        _status = [dictionary[@"status"] copy];
        _ipAddress = [dictionary[@"ip_address"] copy];
        _imageID = [dictionary[@"image_id"] integerValue];
        _regionID = [dictionary[@"region_id"] integerValue];
        _sizeID = [dictionary[@"size_id"] integerValue];
    }
    return self;
}

- (NSString *)imageIDString
{
    return [[NSNumber numberWithInteger:self.imageID] stringValue];
}

- (NSString *)regionIDString
{
    return [[NSNumber numberWithInteger:self.regionID] stringValue];
}

- (NSString *)sizeIDString
{
    return [[NSNumber numberWithInteger:self.sizeID] stringValue];
}

- (BOOL)isActive
{
    return [self.status isEqualToString:@"active"];
}

- (UIColor *)statusColor
{
    return [self isActive] ? [UIColor DOGreenColor] : [UIColor DOGrayColor];
}

- (NSArray *)availableActions
{
    NSMutableArray *actions = [@[] mutableCopy];

    if ([self isActive]) {
        [actions addObject:[DODropletAction rebootAction]];
        [actions addObject:[DODropletAction shutdownAction]];
    } else {
        [actions addObject:[DODropletAction bootAction]];
    }

    return actions;
}

@end
