//
//  DOImage.h
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DOObject.h"

@interface DOImage : DOObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *distribution;

@end
