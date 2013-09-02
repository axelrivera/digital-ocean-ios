//
//  DOObject.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "ARModelObject.h"

@interface DOObject : ARModelObject

@property (assign, nonatomic) NSInteger objectID;

- (NSString *)objectIDString;

@end
