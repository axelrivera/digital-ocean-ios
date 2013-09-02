//
//  ARModelObject.h
//
//  Created by Axel Rivera on 8/30/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARModelObject : NSObject

+ (id)instanceWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

// Helper Category to extract and convert objects from a JSON NSDictionary

@interface NSDictionary (ARModelObject)

- (NSArray *)extractArrayObjectsForKey:(NSString *)key objectClass:(NSString *)classString;
- (id)extractObjectForKey:(NSString *)key objectClass:(NSString *)classString;
- (id)extractObjectValueForKey:(NSString *)key objectClass:(NSString *)objectClass;

- (NSString *)extractStringValueForKey:(NSString *)key;
- (NSInteger)extractIntegerValueForKey:(NSString *)key;
- (CGFloat)extractFloatValueForKey:(NSString *)key;
- (BOOL)extractBoolValueForKey:(NSString *)key;

@end
