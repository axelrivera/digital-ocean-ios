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
        _droplets = [@[] mutableCopy];
        _sizes = @{};
        _regions = @{};
        _images = @{};
        _sizesArray = @[];
        _regionsArray = @[];
        _imagesArray = @[];
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
    [[DigitalOceanAPIClient sharedClient] fetchDropletsWithCompletion:^(NSArray *droplets, NSError *error) {
        if (droplets) {
            self.droplets = [droplets mutableCopy];
        } else {
            self.droplets = [@[] mutableCopy];
        }

        if (completion) {
            completion(droplets, error);
        }
    }];
}

- (void)reloadDropletWithID:(NSInteger)dropletID completion:(DODropletCompletionBlock)completion
{
    [[DigitalOceanAPIClient sharedClient] fetchDropletWithID:dropletID completion:^(DODroplet *droplet, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, completion);
            }
            return;
        }
        
        NSInteger index = [self.droplets indexOfObject:droplet];
        if (index != NSNotFound) {
            [self.droplets replaceObjectAtIndex:index withObject:droplet];
            [[NSNotificationCenter defaultCenter] postNotificationName:DODropletsUpdatedNotification
                                                                object:nil
                                                              userInfo:@{ kUserInfoDropletsKey: self.droplets }];
        }

        if (completion) {
            completion(droplet, nil);
        }
    }];
}

- (void)reloadImagesWithCompletion:(DOImagesCompletionBlock)completion
{
    [[DigitalOceanAPIClient sharedClient] fetchImagesWithCompletion:^(NSArray *images, NSError *error) {
        if (images) {
            self.images = [images dictionaryWithIDKey];
            self.imagesArray = images;
        } else {
            self.images = @{};
            self.imagesArray = @[];
        }

        if (completion) {
            completion(images, error);
        }
    }];
}

- (void)reloadRegionsWithCompletion:(DORegionsCompletionBlock)completion
{
    [[DigitalOceanAPIClient sharedClient] fetchRegionsWithCompletion:^(NSArray *regions, NSError *error) {
        if (regions) {
            self.regions = [regions dictionaryWithIDKey];
            self.regionsArray = regions;
        } else {
            self.regions = @{};
            self.regionsArray = @[];
        }

        if (completion) {
            completion(regions, error);
        }
    }];
}

- (void)reloadSizesWithCompletion:(DOSizesCompletionBlock)completion
{
    [[DigitalOceanAPIClient sharedClient] fetchSizesWithCompletion:^(NSArray *sizes, NSError *error) {
        if (sizes) {
            self.sizes = [sizes dictionaryWithIDKey];
            self.sizesArray = sizes;
        } else {
            self.sizes = @{};
            self.sizesArray = @[];
        }
        
        if (completion) {
            completion(sizes, error);
        }
    }];
}

- (NSString *)regionNameForIDString:(NSString *)string
{
    NSString *name = @"";
    DORegion *region = self.regions[string];
    if (region) {
        name = region.name;
    }
    return name;
}

- (NSString *)imageNameForIDString:(NSString *)string
{
    NSString *name = @"";
    DOImage *image = self.images[string];
    if (image) {
        name = image.name;
    }
        
    return name;
}

- (NSString *)sizeNameForIDString:(NSString *)string
{
    NSString *name = @"";
    DOSize *size = self.sizes[string];
    if (size) {
        name = [NSString stringWithFormat:@"%@ Ram", size.name];
    }
    return name;
}

- (NSString *)diskNameForIDString:(NSString *)string
{
    NSString *name = @"";
    DOSize *size = self.sizes[string];
    if (size) {
        name = [NSString stringWithFormat:@"%@GB SSD", size.disk];
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
