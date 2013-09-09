//
//  DOSnapshot.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DOObject.h"

@interface DOSnapshot : DOObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *distribution;

@end
