//
//  DOData.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DOData.h"

#import "NSArray+DigitalOcean.h"

@implementation DOData

- (id)init
{
    self = [super init];
    if (self) {
        _droplets = @[];
        _images = @{};
        _regions = @{};
        _sizes = @{};
    }
    return self;
}

- (void)reloadInitialDataWithCompletion:(void(^)(void))completion
{
    [self reloadDropletsWithCompletion:^(NSArray *droplets, NSError *error) {
        [self reloadImagesWithCompletion:^(NSArray *images, NSError *error) {
            [self reloadRegionsWithCompletion:^(NSArray *regions, NSError *error) {
                [self reloadSizesWithCompletion:^(NSArray *sizes, NSError *error) {
                    if (completion) {
                        completion();
                    }
                }];
            }];
        }];
    }];
}

- (void)reloadDropletsWithCompletion:(DODropletsCompletionBlock)completion
{
    [[DOAPIClient sharedClient] fetchDropletsWithCompletion:^(NSArray *droplets, NSError *error) {
        if (droplets) {
            self.droplets = droplets;
        } else {
            self.droplets = @[];
        }

        if (completion) {
            completion(droplets, error);
        }
    }];
}

- (void)reloadImagesWithCompletion:(DOImagesCompletionBlock)completion
{
    [[DOAPIClient sharedClient] fetchImagesWithCompletion:^(NSArray *images, NSError *error) {
        if (images) {
            self.images = [images dictionaryWithIDKey];
        } else {
            self.images = @{};
        }

        if (completion) {
            completion(images, error);
        }
    }];
}

- (void)reloadRegionsWithCompletion:(DORegionsCompletionBlock)completion
{
    [[DOAPIClient sharedClient] fetchRegionsWithCompletion:^(NSArray *regions, NSError *error) {
        if (regions) {
            self.regions = [regions dictionaryWithIDKey];
        } else {
            self.regions = @{};
        }

        if (completion) {
            completion(regions, error);
        }
    }];
}

- (void)reloadSizesWithCompletion:(DOSizesCompletionBlock)completion
{
    [[DOAPIClient sharedClient] fetchSizesWithCompletion:^(NSArray *sizes, NSError *error) {
        if (sizes) {
            self.sizes = [sizes dictionaryWithIDKey];
        } else {
            self.sizes = @{};
        }
        
        if (completion) {
            completion(sizes, error);
        }
    }];
}

- (NSString *)regionNameForIDString:(NSString *)string
{
    NSString *name = nil;
     DORegion *region = self.regions[string];
    if (region) {
        name = region.name;
    }
    return name;
}

- (NSString *)imageNameForIDString:(NSString *)string
{
    NSString *name = nil;
    DOImage *image = self.images[string];
    if (image) {
        name = [NSString stringWithFormat:@"%@ (%@)", image.name, image.distribution];
    }
        
    return name;
}

- (NSString *)sizeNameForIDString:(NSString *)string
{
    NSString *name = nil;
    DOSize *size = self.sizes[string];
    if (size) {
        name = size.name;
    }
    return name;
}

#pragma mark - Singleton Methods

+ (DOData *)sharedData
{
    static DOData *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[DOData alloc] init];
    });
    return sharedData;
}

@end
