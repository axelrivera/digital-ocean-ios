//
//  MaritimoAPIClient.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/5/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "MaritimoAPIClient.h"

#import <AFJSONRequestOperation.h>
#import <AFNetworkActivityIndicatorManager.h>

@implementation MaritimoAPIClient

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

#pragma mark - Public Methods

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(DOConfirmationBlock)completion
{
    NSString *path = @"login.json";
    if (email == nil) {
        email = @"";
    }
    
    if (password == nil) {
        password = @"";
    }
    
    NSDictionary *parameters = @{ @"email" : email, @"password" : password };
    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *clientID = responseObject[@"client_id"];
        NSString *APIKey = responseObject[@"api_key"];
        
        if (IsEmpty(clientID) || IsEmpty(APIKey)) {
            if (completion) {
                completion(NO, [ARError error]);
            }
            return;
        }
        
        [self setClientID:clientID];
        [self setAPIKey:APIKey];
        
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Authentication Error: %@", error);
        if (completion) {
            completion(NO, error);
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
    [self setClientID:nil];
    [self setAPIKey:nil];
}

- (void)logout
{
    [self invalidateAuthentication];
    [[NSNotificationCenter defaultCenter] postNotificationName:DOUserDidLogoutNotification object:nil];
}

#pragma mark - Singleton Methods

+ (MaritimoAPIClient *)sharedClient
{
    static MaritimoAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *URLStr = kMaritimoHost;
		DLog(@"Init Maritimo API Client: %@", URLStr);
        sharedClient = [[MaritimoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:URLStr]];
    });
    return sharedClient;
}

@end
