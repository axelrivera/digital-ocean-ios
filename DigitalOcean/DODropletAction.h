//
//  DODropletAction.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDropletActionIdentifierBoot @"boot"
#define kDropletActionIdentifierShutdown @"shutdown"
#define kDropletActionIdentifierReboot @"reboot"

typedef NS_ENUM(NSInteger, DODropletActionType) {
    DODropletActionTypeNone = 0,
    DODropletActionTypeBoot,
    DODropletActionTypeShutDown,
    DODropletActionTypeReboot
};

@interface DODropletAction : NSObject

@property (assign, nonatomic) DODropletActionType actionType;

+ (DODropletAction *)actionWithType:(DODropletActionType)actionType;

+ (DODropletAction *)bootAction;
+ (DODropletAction *)shutdownAction;
+ (DODropletAction *)rebootAction;

+ (NSString *)titleForActionType:(DODropletActionType)actionType;
+ (NSString *)pathForActionType:(DODropletActionType)actionType;

- (NSString *)name;

@end
