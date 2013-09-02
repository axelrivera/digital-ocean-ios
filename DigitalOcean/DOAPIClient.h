//
//  DOAPIClient.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFHTTPClient.h>

typedef void(^DODropletsCompletionBlock)(NSArray *droplets, NSError *error);
typedef void(^DOImagesCompletionBlock)(NSArray *images, NSError *error);
typedef void(^DORegionsCompletionBlock)(NSArray *regions, NSError *error);
typedef void(^DOSizesCompletionBlock)(NSArray *sizes, NSError *error);

typedef void(^DOConfirmationBlock)(BOOL success, NSError *error);
typedef void(^DOCompletionBlock)(id object, NSError *error);
typedef void(^DOErrorBlock)(NSError *error);

@interface DOAPIClient : AFHTTPClient

+ (DOAPIClient *)sharedClient;

- (void)fetchDropletsWithCompletion:(DODropletsCompletionBlock)completion;

- (void)dropletAction:(DODropletActionType)dropletAction
            dropletID:(NSInteger)dropletID
           checkEvent:(BOOL)checkEvent
                 wait:(BOOL)wait
           completion:(DOConfirmationBlock)completion;

- (void)fetchImagesWithCompletion:(DOImagesCompletionBlock)completion;
- (void)fetchRegionsWithCompletion:(DORegionsCompletionBlock)completion;
- (void)fetchSizesWithCompletion:(DOSizesCompletionBlock)completion;

- (void)validateEventWithID:(NSInteger)eventID wait:(BOOL)wait completion:(DOConfirmationBlock)completion;

- (NSString *)clientID;
- (NSString *)APIKey;

@end
