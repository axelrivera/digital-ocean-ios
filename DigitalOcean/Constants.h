//
//  Constants.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#define kMaritimoHost @"https://maritimo.herokuapp.com"

#define kDigitalOceanHost @"https://api.digitalocean.com"
//#define kDigitalOceanHost @"https://ocean-sharingan.fwd.wf/"

//#define kDigitalOceanTestClientID @"web-client"
//#define kDigitalOceanTestApiKey @"12345"

// Notifications

#define DOInitialDataReloadedNotification @"DigitalOceanInitialDataNotification"
#define DODropletsUpdatedNotification @"DigitalOceanDropletsUpdatedNotification"
#define DOUserDidLoginNotification @"DigitalOceanUserDidLoginNotification"
#define DOUserDidLogoutNotification @"DigitalOceanUserDidLogoutNotification"

#define kDigitalOceanClientIDKey @"DigitalOceanClientIDKey"
#define kDigitalOceanAPIKeyKey @"DigitalOceanAPIKeyKey"

#define kUserInfoDropletsKey @"droplets"

#define kLabelDictionaryKey @"label"
#define kValueDictionaryKey @"value"
#define kColorDictionaryKey @"color"
#define kNavigationDictionaryKey @"navigation"

#define NSStringFromBOOL(value) value ? @"YES" : @"NO"

#define rgb(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || thing == [NSNull null]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}