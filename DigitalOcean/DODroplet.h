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

@property (assign, nonatomic) BOOL backupsActive;

- (NSString *)imageIDString;
- (NSString *)regionIDString;
- (NSString *)sizeIDString;

- (BOOL)isActive;
- (UIColor *)statusColor;

- (NSArray *)availableActions;

@end
