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
        
        _backupsActive = [dictionary[@"backups_active"] boolValue];

        _backups = [dictionary extractArrayObjectsForKey:@"backups"
                                             objectClass:NSStringFromClass([DOBackup class])];

        _snapshots = [dictionary extractArrayObjectsForKey:@"snapshots"
                                               objectClass:NSStringFromClass([DOSnapshot class])];

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

- (NSString *)formattedStatus
{
    return [self.status capitalizedString];
}

- (NSString *)formattedBackupStatus
{
    return self.backupsActive ? @"Enabled" : @"Disabled";
}

- (UIColor *)backupStatusColor
{
    return self.backupsActive ? [UIColor do_greenColor] : [UIColor do_grayColor];
}

- (BOOL)isActive
{
    return [self.status isEqualToString:@"active"];
}

- (UIColor *)statusColor
{
    return [self isActive] ? [UIColor do_greenColor] : [UIColor do_grayColor];
}

- (NSString *)regionName
{
    return [[DOData sharedData] regionNameForIDString:self.regionIDString];
}

- (NSString *)memoryName
{
    return [[DOData sharedData] sizeNameForIDString:self.sizeIDString];
}

- (NSString *)diskName
{
    return [[DOData sharedData] diskNameForIDString:self.sizeIDString];
}

- (NSString *)distributionName
{
    return [[DOData sharedData] imageNameForIDString:self.imageIDString];
}

- (NSArray *)tableArray
{
    return @[ [self informationArray], [self snapshotsAndBackupsArray] ];
}

- (NSArray *)informationArray
{
    NSMutableArray *array = [@[] mutableCopy];

    NSString *string = nil;
    NSDictionary *dictionary = nil;

//    string = IsEmpty(self.name) ? @"" : self.name;
//    dictionary = @{ kLabelDictionaryKey : @"Name", kValueDictionaryKey : string };
//
//    [array addObject:dictionary];

    string = IsEmpty(self.ipAddress) ? @"" : self.ipAddress;
    dictionary = @{ kLabelDictionaryKey : @"Address", kValueDictionaryKey : string };

    [array addObject:dictionary];

    string = IsEmpty(self.status) ? @"" : [self formattedStatus];
    dictionary = @{ kLabelDictionaryKey : @"Status",
                    kValueDictionaryKey : string,
                    kColorDictionaryKey : self.statusColor };

    [array addObject:dictionary];
    
    string = [self formattedBackupStatus];
    dictionary = @{ kLabelDictionaryKey : @"Backups",
                    kValueDictionaryKey : string,
                    kColorDictionaryKey : [self backupStatusColor] };
    
    [array addObject:dictionary];

    string = [self regionName];
    dictionary = @{ kLabelDictionaryKey : @"Region", kValueDictionaryKey : string };

    [array addObject:dictionary];

    string = [self memoryName];
    dictionary = @{ kLabelDictionaryKey : @"Memory", kValueDictionaryKey : string };

    [array addObject:dictionary];

    string = [self diskName];
    dictionary = @{ kLabelDictionaryKey : @"Disk", kValueDictionaryKey : string };

    [array addObject:dictionary];

    string = [self distributionName];
    dictionary = @{ kLabelDictionaryKey : @"Image", kValueDictionaryKey : string };

    [array addObject:dictionary];

    return array;
}

- (NSArray *)snapshotsAndBackupsArray
{
    NSMutableArray *array = [@[] mutableCopy];

    NSDictionary *dictionary = nil;

    dictionary = @{ kLabelDictionaryKey: @"Snapshots & Backups", kNavigationDictionaryKey : @YES };
    [array addObject:dictionary];

    return array;
}

@end
