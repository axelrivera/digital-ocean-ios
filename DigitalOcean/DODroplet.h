//
//  DODroplet.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DOObject.h"

@interface DODroplet : DOObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *ipAddress;

@property (assign, nonatomic) NSInteger imageID;
@property (assign, nonatomic) NSInteger regionID;
@property (assign, nonatomic) NSInteger sizeID;

@property (strong, nonatomic) NSArray *snapshots;
@property (strong, nonatomic) NSArray *backups;

@property (assign, nonatomic) BOOL backupsActive;

- (NSString *)imageIDString;
- (NSString *)regionIDString;
- (NSString *)sizeIDString;

- (NSString *)formattedStatus;

- (NSString *)formattedBackupStatus;
- (UIColor *)backupStatusColor;

- (BOOL)isActive;
- (UIColor *)statusColor;

- (NSString *)regionName;
- (NSString *)memoryName;
- (NSString *)diskName;
- (NSString *)distributionName;

- (NSArray *)tableArray;
- (NSArray *)informationArray;
- (NSArray *)snapshotsAndBackupsArray;

@end
