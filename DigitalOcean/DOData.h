//
//  DOData.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOData : NSObject

@property (strong, nonatomic) NSMutableArray *droplets;
@property (strong, nonatomic) NSDictionary *regions;
@property (strong, nonatomic) NSDictionary *images;
@property (strong, nonatomic) NSDictionary *sizes;

- (void)reloadInitialDataWithCompletion:(void(^)(void))completion;

- (void)reloadDropletsWithCompletion:(DODropletsCompletionBlock)completion;
- (void)reloadDropletWithID:(NSInteger)dropletID completion:(DODropletCompletionBlock)completion;

- (void)reloadImagesWithCompletion:(DOImagesCompletionBlock)completion;
- (void)reloadRegionsWithCompletion:(DORegionsCompletionBlock)completion;
- (void)reloadSizesWithCompletion:(DOSizesCompletionBlock)completion;

+ (DOData *)sharedData;

- (NSString *)regionNameForIDString:(NSString *)string;
- (NSString *)imageNameForIDString:(NSString *)string;
- (NSString *)sizeNameForIDString:(NSString *)string;

@end
