//
//  DODropletAction.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DODropletAction.h"

@implementation DODropletAction

+ (NSString *)titleForActionType:(DODropletActionType)actionType
{
    NSString *title = nil;
    switch (actionType) {
        case DODropletActionTypeBoot:
            title = @"Boot";
            break;
        case DODropletActionTypeShutDown:
            title = @"Shut Down";
            break;
        case DODropletActionTypeReboot:
            title = @"Reboot";
            break;
        case DODropletActionTypeResetPassword:
            title = @"Password Reset";
            break;
        case DODropletActionTypeTakeSnapshot:
            title = @"Take Snapshot";
            break;
        case DODropletActionTypeEnableBackups:
            title = @"Enable Backups";
            break;
        case DODropletActionTypeDisableBackups:
            title = @"Disable Backups";
            break;
        default:
            title = @"None";
            break;
    }
    return title;
}

+ (NSString *)pathForActionType:(DODropletActionType)actionType
{
    NSString *path = nil;
    switch (actionType) {
        case DODropletActionTypeBoot:
            path = @"power_on";
            break;
        case DODropletActionTypeShutDown:
            path = @"power_off";
            break;
        case DODropletActionTypeReboot:
            path = @"reboot";
            break;
        case DODropletActionTypeResetPassword:
            path = @"password_reset";
            break;
        case DODropletActionTypeTakeSnapshot:
            path = @"snapshot";
            break;
        case DODropletActionTypeEnableBackups:
            path = @"enable_backups";
            break;
        case DODropletActionTypeDisableBackups:
            path = @"disable_backups";
            break;
        default:
            path = @"";
            break;
    }
    return path;
}

@end
