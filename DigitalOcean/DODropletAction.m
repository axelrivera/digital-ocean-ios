//
//  DODropletAction.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DODropletAction.h"

@implementation DODropletAction

+ (DODropletAction *)actionWithType:(DODropletActionType)actionType
{
    DODropletAction *action = [[DODropletAction alloc] init];
    action.actionType = actionType;
    return action;
}

+ (DODropletAction *)bootAction
{
    return [DODropletAction actionWithType:DODropletActionTypeBoot];
}

+ (DODropletAction *)shutdownAction
{
    return [DODropletAction actionWithType:DODropletActionTypeShutDown];
}

+ (DODropletAction *)rebootAction
{
    return [DODropletAction actionWithType:DODropletActionTypeReboot];
}

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
        default:
            path = @"";
            break;
    }
    return path;
}

- (id)init
{
    self = [super init];
    if (self) {
        _actionType = DODropletActionTypeNone;
    }
    return self;
}

- (NSString *)name
{
    return [[self class] titleForActionType:self.actionType];
}

@end
