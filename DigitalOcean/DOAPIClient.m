//
//  DOAPIClient.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DOAPIClient.h"

#import <AFJSONRequestOperation.h>
#import <AFNetworkActivityIndicatorManager.h>

#define kHTTPGet @"GET"
#define kHTTPPost @"POST"
#define kHTTPPut @"PUT"
#define kHTTPDelete @"DELETE"

@interface DOAPIClient ()

- (NSMutableDictionary *)authDictionary;

- (void)actionWithMethod:(NSString *)method
                    path:(NSString *)path
              parameters:(NSDictionary *)parameters
              completion:(DOCompletionBlock)completion;

- (void)getAuthPath:(NSString *)path
         parameters:(NSDictionary *)parameters
         completion:(DOCompletionBlock)completion;

@end

@implementation DOAPIClient

- (id)initWithBaseURL:(NSURL *)URL
{
    self = [super initWithBaseURL:URL];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    }
    return self;
}

#pragma mark - Private Methods

- (void)actionWithMethod:(NSString *)method
                    path:(NSString *)path
              parameters:(NSDictionary *)parameters
              completion:(DOCompletionBlock)completion
{
    DLog(@"Sending Request with method: %@, path: %@", method, path);
    DLog(@"Parameters: %@", parameters);

    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];

    void (^successBlock)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"Got Response for method: %@, path: %@", method, path);
        DLog(@"%@", responseObject);
        if (completion) {
            completion(responseObject, nil);
        }
    };

    void (^failureBlock)(AFHTTPRequestOperation*, NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Got Error for method: %@, path: %@", method, path);
        DLog(@"%@", error);
        if (completion) {
            completion(nil, error);
        }
    };

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:failureBlock];
    [operation start];
}

#pragma mark - Public Methods

- (void)getAuthPath:(NSString *)path
         parameters:(NSDictionary *)parameters
         completion:(DOCompletionBlock)completion
{
    NSMutableDictionary *dictionary = [self authDictionary];
    [dictionary addEntriesFromDictionary:parameters];
    [self actionWithMethod:kHTTPGet path:path parameters:dictionary completion:completion];
}

- (void)fetchDropletsWithCompletion:(DODropletsCompletionBlock)completion
{
    NSString *path = @"droplets";
    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(@[], error);
            }
            return;
        }

        NSArray *droplets = [object extractArrayObjectsForKey:@"droplets"
                                            objectClass:NSStringFromClass([DODroplet class])];
        if (completion) {
            completion(droplets, nil);
        }
    }];
}

- (void)dropletAction:(DODropletActionType)dropletAction
            dropletID:(NSInteger)dropletID
           checkEvent:(BOOL)checkEvent
                 wait:(BOOL)wait
           completion:(DOConfirmationBlock)completion
{
    if (dropletAction == DODropletActionTypeNone) {
        DLog(@"Droplet Action Cannot be None!!");
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"droplets/%d/%@",
                      dropletID, [DODropletAction pathForActionType:dropletAction]];

    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }

        if (checkEvent) {
            NSInteger eventID = [object extractIntegerValueForKey:@"event_id"];
            [self validateEventWithID:eventID wait:wait completion:^(BOOL success, NSError *error) {
                if (error) {
                    if (completion) {
                        completion(NO, error);
                    }
                    return;
                }

                if (completion) {
                    completion(success, nil);
                }
            }];
        } else {
            if (completion) {
                completion(YES, nil);
            }
        }
    }];
}

- (void)fetchImagesWithCompletion:(DOImagesCompletionBlock)completion
{
    NSString *path = @"images";
    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(@[], error);
            }
            return;
        }

        NSArray *images = [object extractArrayObjectsForKey:@"images"
                                          objectClass:NSStringFromClass([DOImage class])];
        if (completion) {
            completion(images, nil);
        }
    }];
}

- (void)fetchRegionsWithCompletion:(DORegionsCompletionBlock)completion
{
    NSString *path = @"regions";
    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(@[], error);
            }
            return;
        }

        NSArray *regions = [object extractArrayObjectsForKey:@"regions"
                                           objectClass:NSStringFromClass([DORegion class])];
        if (completion) {
            completion(regions, nil);
        }
    }];
}

- (void)fetchSizesWithCompletion:(DOSizesCompletionBlock)completion
{
    NSString *path = @"sizes";
    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(@[], error);
            }
            return;
        }

        NSArray *sizes = [object extractArrayObjectsForKey:@"sizes"
                                         objectClass:NSStringFromClass([DOSize class])];
        if (completion) {
            completion(sizes, nil);
        }
    }];
}

- (void)validateEventWithID:(NSInteger)eventID wait:(BOOL)wait completion:(DOConfirmationBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"events/%d", eventID];

    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        NSDictionary *event = object[@"event"];
        NSString *status = [event extractStringValueForKey:@"action_status"];
        
        DLog(@"Action Status: %@", status);
        
        if ([status isEqualToString:@"done"]) {
            if (completion) {
                completion(YES, nil);
                return;
            }
        } else {
            if (!IsEmpty(status) && wait) {
                [self validateEventWithID:eventID wait:wait completion:completion];
            } else {
                if (completion) {
                    completion(NO, nil);
                }
            }
        }
    }];
}

- (NSString *)clientID
{
    NSString *string = nil;
#ifdef kDigitalOceanTestClientID
    string = kDigitalOceanTestClientID;
#else
    string = @"kGKyn6OyznKG2mtxijQih";
#endif
    return string;;
}

- (NSString *)APIKey
{
    NSString *string = nil;
#ifdef kDigitalOceanTestApiKey
    string = kDigitalOceanTestApiKey;
#else
    string = @"TsU8eI7Ss5bdBMmH8RP1zRQfautlrxAwNYZRFZHSr";
#endif
    return string;
}

- (NSMutableDictionary *)authDictionary
{
    return [@{ @"client_id" : [self clientID], @"api_key" : [self APIKey] } mutableCopy];
}

#pragma mark - Singleton Methods

+ (DOAPIClient *)sharedClient
{
    static DOAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *URLStr = kDigitalOceanHost;
		DLog(@"Init Digital Ocean API Client: %@", URLStr);
        sharedClient = [[DOAPIClient alloc] initWithBaseURL:[NSURL URLWithString:URLStr]];
    });
    return sharedClient;
}

@end
