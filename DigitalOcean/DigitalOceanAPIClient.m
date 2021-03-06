//
//  DigitalOceanAPIClient.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DigitalOceanAPIClient.h"

#import <AFJSONRequestOperation.h>
#import <AFNetworkActivityIndicatorManager.h>

#define kHTTPGet @"GET"
#define kHTTPPost @"POST"
#define kHTTPPut @"PUT"
#define kHTTPDelete @"DELETE"

@interface DigitalOceanAPIClient ()

- (NSMutableDictionary *)authDictionary;

- (void)actionWithMethod:(NSString *)method
                    path:(NSString *)path
              parameters:(NSDictionary *)parameters
              completion:(DOCompletionBlock)completion;

- (void)getAuthPath:(NSString *)path
         parameters:(NSDictionary *)parameters
         completion:(DOCompletionBlock)completion;

@end

@implementation DigitalOceanAPIClient

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

        if (operation.response.statusCode == 401) {
            [self logout];
        }

        if (completion) {
            completion(nil, error);
        }
    };

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:failureBlock];
    [operation start];
}

- (void)getAuthPath:(NSString *)path
         parameters:(NSDictionary *)parameters
         completion:(DOCompletionBlock)completion
{
    NSMutableDictionary *dictionary = [self authDictionary];
    [dictionary addEntriesFromDictionary:parameters];
    [self actionWithMethod:kHTTPGet path:path parameters:dictionary completion:completion];
}

#pragma mark - Public Methods

- (void)validateClientID:(NSString *)clientID APIKey:(NSString *)APIKey completion:(DOConfirmationBlock)completion
{
    if (IsEmpty(clientID) || IsEmpty(APIKey)) {
        if (completion) {
            completion(NO, [ARError error]);
        }
        return;
    }

    NSString *path = @"sizes";
    NSDictionary *parameters = @{ @"client_id" : clientID, @"api_key" : APIKey };
    DLog(@"Validating Credentials With Parameters:");
    DLog(@"%@", parameters);

    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"Credential Validation Response: %@", responseObject);
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Credential Validation Error: %@", error);
        if (completion) {
            completion(NO, error);
        }
    }];
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

- (void)fetchDropletWithID:(NSInteger)dropletID completion:(DODropletCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"droplets/%d", dropletID];
    [self getAuthPath:path parameters:nil completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }

        DODroplet *droplet = [object extractObjectForKey:@"droplet"
                                             objectClass:NSStringFromClass([DODroplet class])];

        if (completion) {
            completion(droplet, nil);
        }
    }];
}

- (void)dropletAction:(DODropletActionType)dropletAction
            dropletID:(NSInteger)dropletID
           checkEvent:(BOOL)checkEvent
                 wait:(BOOL)wait
           completion:(DOConfirmationBlock)completion
{
    [self dropletAction:dropletAction
              dropletID:dropletID
                options:nil
             checkEvent:checkEvent
                   wait:wait
             completion:completion];
}

- (void)dropletAction:(DODropletActionType)dropletAction
            dropletID:(NSInteger)dropletID
              options:(NSDictionary *)options
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
    
    [self getAuthPath:path parameters:options completion:^(id object, NSError *error) {
        if (error) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        NSString *status = [object extractStringValueForKey:@"status"];
        if (![status isEqualToString:@"OK"]) {
            if (completion) {
                completion(NO, [ARError error]);
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
            if (wait) {
                DLog(@"Wait before calling event!");
                [NSThread sleepForTimeInterval:2.0];
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
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kDigitalOceanClientIDKey];
    return IsEmpty(string) ? @"" : string;
}

- (void)setClientID:(NSString *)clientID
{
    [[NSUserDefaults standardUserDefaults] setObject:clientID forKey:kDigitalOceanClientIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)APIKey
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kDigitalOceanAPIKeyKey];
    return IsEmpty(string) ? @"" : string;
}

- (void)setAPIKey:(NSString *)APIKey
{
    [[NSUserDefaults standardUserDefaults] setObject:APIKey forKey:kDigitalOceanAPIKeyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isAuthenticated
{
    return !IsEmpty([self clientID]) && !IsEmpty([self APIKey]);
}

- (void)invalidateAuthentication
{
    [self setAPIKey:nil];
}

- (void)logout
{
    [self invalidateAuthentication];
    [[NSNotificationCenter defaultCenter] postNotificationName:DOUserDidLogoutNotification object:nil];
}

- (NSMutableDictionary *)authDictionary
{
    return [@{ @"client_id" : [self clientID], @"api_key" : [self APIKey] } mutableCopy];
}

#pragma mark - Singleton Methods

+ (DigitalOceanAPIClient *)sharedClient
{
    static DigitalOceanAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *URLStr = kDigitalOceanHost;
		DLog(@"Init Digital Ocean API Client: %@", URLStr);
        sharedClient = [[DigitalOceanAPIClient alloc] initWithBaseURL:[NSURL URLWithString:URLStr]];
    });
    return sharedClient;
}

@end
