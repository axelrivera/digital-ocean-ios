//
//  DODropletAction.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DODropletActionType) {
    DODropletActionTypeNone = -1,
    DODropletActionTypeBoot,
    DODropletActionTypeShutDown,
    DODropletActionTypeReboot,
    DODropletActionTypeResetPassword,
    DODropletActionTypeTakeSnapshot,
    DODropletActionTypeEnableBackups,
    DODropletActionTypeDisableBackups
};

@interface DODropletAction : NSObject

+ (NSString *)titleForActionType:(DODropletActionType)actionType;
+ (NSString *)pathForActionType:(DODropletActionType)actionType;

@end
