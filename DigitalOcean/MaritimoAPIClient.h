//
//  MaritimoAPIClient.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/5/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <AFHTTPClient.h>

@interface MaritimoAPIClient : AFHTTPClient

+ (MaritimoAPIClient *)sharedClient;

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(DOConfirmationBlock)completion;

- (NSString *)clientID;
- (void)setClientID:(NSString *)clientID;

- (NSString *)APIKey;
- (void)setAPIKey:(NSString *)APIKey;

- (BOOL)isAuthenticated;
- (void)invalidateAuthentication;
- (void)logout;

@end
