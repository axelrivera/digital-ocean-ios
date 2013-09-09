//
//  DigitalOcean.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

typedef void(^DOConfirmationBlock)(BOOL success, NSError *error);
typedef void(^DOCompletionBlock)(id object, NSError *error);
typedef void(^DOErrorBlock)(NSError *error);

#import "ARError.h"
#import "UIColor+DigitalOcean.h"
#import "ARModelObject.h"
#import "DOObject.h"
#import "DODroplet.h"
#import "DODropletAction.h"
#import "DORegion.h"
#import "DOImage.h"
#import "DOSize.h"
#import "DOBackup.h"
#import "DOSnapshot.h"
#import "MaritimoAPIClient.h"
#import "DigitalOceanAPIClient.h"
#import "DOData.h"
